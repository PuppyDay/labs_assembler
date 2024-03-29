; Template for console application
         .586
         .MODEL  flat, stdcall
         OPTION CASEMAP:NONE

Include kernel32.inc
Include masm32.inc

IncludeLib kernel32.lib
IncludeLib masm32.lib

         .CONST
MsgExit  DB    13, 10,"Press Enter to Exit",0AH,0DH,0
MsgZero  DB    13, 10,"Error: division by 0", 13, 10, 0

         .DATA
ZaprosA   DB     'Input A',13,10,0
ZaprosB   DB     13,10,'Input B',13,10,0
ZaprosD   DB     13,10,'Input D',13,10,0
Result    DB     13, 10,'Result = ',0
RES       DB     16 DUP (' '),0

         .DATA?
Buffer   DB      10 DUP (?) 
A        SDWORD  ?
B        SDWORD  ?
D        SDWORD  ?
X        SDWORD  ?
inbuf    DB      100 DUP (?)

         .CODE
Start:
         Invoke StdOut,ADDR ZaprosA                 ; ���� ���������� A
         Invoke StdIn,ADDR Buffer,LengthOf Buffer
         Invoke StripLF,ADDR Buffer
         Invoke atol,ADDR Buffer 
         MOV    DWORD PTR A,EAX
         
         Invoke StdOut,ADDR ZaprosB                 ; ���� ���������� B 
         Invoke StdIn,ADDR Buffer,LengthOf Buffer
         Invoke StripLF,ADDR Buffer
         Invoke atol,ADDR Buffer 
         MOV    DWORD PTR B,EAX
         
         Invoke StdOut,ADDR ZaprosD                 ; ���� ���������� D
         Invoke StdIn,ADDR Buffer,LengthOf Buffer
         Invoke StripLF,ADDR Buffer
         Invoke atol,ADDR Buffer 
         MOV    DWORD PTR D,EAX
         
         CMP    EAX, 0                                 ; �������� �� ��, �� ����� �� 0
         je     error
            TEST   A, 1                                ; �������� �� �������� ����������� � � ��������
            JNP    odd                                 ; � ������ ���������� ������������ �� ��������������� �����
                MOV    EAX, 2                              ; ���� �������� � ������ ��������
                IMUL   B
                MOV    EBX, EAX
                MOV    EAX, A
                CDQ
                IDIV   D
                SBB    EAX, EBX
                MOV    X, EAX                            
                JMP    continue  
            odd:   MOV    X, -8                        ; ���� �������,���� ����� ��������
            continue:  Invoke dwtoa,X,ADDR RES         ; ����� ����������
            Invoke StdOut,ADDR Result
            Invoke StdOut,ADDR RES
            JMP     end_if
         error: Invoke StdOut,ADDR MsgZero
         end_if:    XOR    EAX, EAX
         Invoke StdOut,ADDR MsgExit
         Invoke StdIn,ADDR inbuf,LengthOf inbuf		
	
         Invoke ExitProcess,0
         End    Start
