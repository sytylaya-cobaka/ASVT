.586
.MODEL flat, C
OPTION CASEMAP:NONE

.DATA
SUM     REAL4 0.0
i_local DWORD 0

.CODE
EXTERN fun_el:PROC
PUBLIC SumR

SumR PROC C
    push ebp
    mov ebp, esp

    fldz
    fstp SUM

    mov i_local, 1
    mov ecx, DWORD PTR [ebp + 8]

    cmp ecx, 0
    jle finish

cycle_start:
    push ecx

    push DWORD PTR [ebp + 12]   ; x
    push i_local                ; k
    call fun_el
    add esp, 8

    fld SUM
    faddp ST(1), ST(0)
    fstp SUM

    pop ecx

    inc i_local
    loop cycle_start

finish:
    fld SUM

    mov esp, ebp
    pop ebp
    ret
SumR ENDP

END