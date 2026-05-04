.686
.model flat,stdcall
.stack 100h

.data
X db 100
Y db 21
Z db 4
M dw ?

.code
ExitProcess PROTO STDCALL :DWORD

Start:
xor eax, eax
xor ebx, ebx
xor ecx, ecx
xor edx, edx

mov al, X
ror al, 3

mov bl, Y
ror bl, 3

mov cl, Z
ror cl, 3

imul ax, 3

add ax, bx

or ax, cx

mov M, ax

invoke ExitProcess, 0
end Start