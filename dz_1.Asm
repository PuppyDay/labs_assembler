; Template for console application
         .586
         .MODEL  flat, stdcall
         OPTION CASEMAP:NONE

Include kernel32.inc
Include masm32.inc

IncludeLib kernel32.lib
IncludeLib masm32.lib

         .CONST
MsgExit  DB    13, 10, "Press Enter to Exit",0AH,0DH,0
Strr     DB    "aeiouyAEIOUY", 0
Zapros   DB    "Input string:   "
Prob     DB    20h, 20h, 0
Dvoetoch DB    "  consonantal:  ", 0
Ent      DB    13, 10, 0
VLV      DB    "  vowels  ", 0

         .DATA
Buffer   DB    100  DUP(0)

         .DATA?
inbuf    DB    100 DUP (?)
ResMass  DB    100  DUP (?)
RES      DB    100  DUP (?)
COUNTER  DWord    ?
CURRENT  DWord    ?
CUR  DWord    ?


         .CODE
Start:
         Invoke StdOut,ADDR Zapros
         Invoke StdIn,ADDR Buffer,LengthOf Buffer
         Invoke StripLF,ADDR Buffer            ; ������ ���� ������


        LEA ESI,    Buffer                     ; ������� �������� ����� ������, ���� ��������� �� ���
        MOV EBX,    0                          ; �������� ������� �������
        MOV ECX,    0                          ; �������� ������� ���� � �����
        LEA EDI,    Strr                       ; ��������� ���� ������ � �������� � ��������
        MOV EDX,    0
        CLD                                    ; �������� �������� � ������� ����������� � ����. � ����.
        LODSB

    cycle:  cmp EAX,    0                      ; ��������� �� ����� �� ������
            je end_cycle                       ; ���� ����� ������� �� �����
                cmp     EAX, 20h               ; ���� �� ����� �������, ���� � ��������������������
                je probel
                    inc BL                     ; ����������� ������� ���� � �����
                    cld
                    push    ECX                ; ��������� � ���� ������� �������, ���� ������������ ��� ��� �����
                    MOV     ECX, 12            ; ������������� ����� ������ �������
                    REPNE SCASB
                    LEA     EDI, Strr          ; ���������� ������ � ������� �������� � EAX, ���� �� �����,���� ��, ������ ������������ �������
                    pop     ECX                ; �������� �� ����� ������� ������� �������
                    jne no_glas                ; ��������� �������� �� ������ ����� �������, �� ���� �� ��������� ���� ��������
                        inc CL
                    no_glas: jmp continue
                probel: cmp     EBX, 0
                je no_write
                    MOV     ResMass[EDX], CL   ; ���� ������, �� ���������� � ������ ���-�� �������
                    SUB     BL, CL
                    inc     EDX
                    MOV     ResMass[EDX], BL   ; � ���������
                    inc     EDX
                    MOV     EBX, 0             ; �������� ��������
                    MOV     ECX, 0
                    inc     COUNTER
                no_write:
               continue: CLD
               LODSB
               jmp      cycle
            end_cycle:
            MOV     ResMass[EDX], CL           ; ���� ������, �� ���������� � ������ ���-�� �������
            SUB     BL, CL
            inc     EDX
            MOV     ResMass[EDX], BL           ; � ���������
            inc     COUNTER
             
             
             
             
             mov    EAX, 0                                    
             mov    EDX, 0   
             mov    EBX, 0                     ; ������� ��������, � ������������� �������
             mov    ECX, COUNTER   
             inc    CURRENT                  
              
  cycle2:  mov      EBX, 0                     ; �������� �� ��, �� ���������� �� ����� �����
           cmp      ResMass[EDX], BL
           jne      no_z
                cmp     ResMass+1[EDX], BL
                je no_wr
           no_z:    push    ECX
           push     EDX
           mov      EBX, 0
           mov      BL, ResMass[EDX]           ; ����� ���������� ������� � ���������
           Invoke dwtoa,EBX,ADDR RES
           Invoke StdOut,ADDR RES 
           Invoke StdOut,ADDR VLV
           pop      EDX
           push     EDX
           mov      BL, ResMass+1[EDX]
           Invoke dwtoa,EBX,ADDR RES
           Invoke StdOut,ADDR RES
           Invoke StdOut,ADDR Dvoetoch          
           Invoke dwtoa,CURRENT,ADDR RES
           Invoke StdOut,ADDR RES
           pop      EDX
           mov      ax, word ptr ResMass[EDX] 
           push     EDX  
           mov      ECX, COUNTER
           sub      ECX, CURRENT   
           inc      CURRENT
           mov      ebx, CURRENT
           mov      CUR, ebx 
           cmp      ECX, 0    
           je       end_2                
           cycle_in:    add     EDX, 2
                        cmp     ax, word ptr ResMass[EDX]         ; ����� ����� � ������ ����������� ������ � ���������
                        jne     ne_ravn
                            push        ECX
                            push        EDX
                            push        EAX
                            Invoke StdOut,ADDR Prob  
                            Invoke dwtoa,CUR,ADDR RES
                            Invoke StdOut,ADDR RES
                            pop     EAX
                            pop     EDX                         
                            pop     ECX
                            mov     ResMass[EDX], 0
                            mov     ResMass+1[EDX], 0
                            jmp     end_in
                       ne_ravn: 
                       end_in:   inc    CUR
          loop      cycle_in
          Invoke StdOut,ADDR Ent
          pop       EDX
          pop       ECX  
          jmp       cnt
              no_wr:inc     CURRENT
          cnt:    add      EDX, 2
          dec       ECX
          end_2:
   jne cycle2
         
         XOR    EAX,EAX
         Invoke StdOut,ADDR MsgExit
         Invoke StdIn,ADDR inbuf,LengthOf inbuf		
	
         Invoke ExitProcess,0
         End    Start

