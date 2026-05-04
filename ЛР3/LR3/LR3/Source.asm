; 1 - треугольник 
; 0 - НЕ треугольник 


.586
.MODEL FLAT, C

.DATA

coords1 REAL4  5.5, 3.2     
        REAL4  2.1, 7.8     
        REAL4  1.3, 4.5     

coords2 REAL4  0.0, 0.0      
        REAL4  5.0, 0.0     
        REAL4  10.0, 0.0     

coords3 REAL8  -2.5, -1.5
        REAL8  -4.0, -3.0
        REAL8  -1.0, -4.5

coords4 REAL10 12345.6789, 23456.7891
        REAL10 34567.8912, 45678.9123
        REAL10 56789.1234, 67891.2345

x1 REAL8 ?
y1 REAL8 ?
x2 REAL8 ?
y2 REAL8 ?
x3 REAL8 ?
y3 REAL8 ?

res1 DWORD ?
res2 DWORD ?
res3 DWORD ?
res4 DWORD ?

.CODE

start:
    mov esi, OFFSET coords1
    call LoadReal4ToBuffer
    call CheckTriangleDet
    mov res1, eax
    
    mov esi, OFFSET coords2
    call LoadReal4ToBuffer
    call CheckTriangleDet
    mov res2, eax
    
    mov esi, OFFSET coords3
    call LoadReal8ToBuffer
    call CheckTriangleDet
    mov res3, eax
    
    mov esi, OFFSET coords4
    call LoadReal10ToBuffer
    call CheckTriangleDet
    mov res4, eax
    
DEBUG_STOP:
    nop
    jmp DEBUG_STOP

LoadReal4ToBuffer PROC
    fld DWORD PTR [esi]
    fstp x1
    
    fld DWORD PTR [esi+4]
    fstp y1
    
    fld DWORD PTR [esi+8]
    fstp x2
    
    fld DWORD PTR [esi+12]
    fstp y2
    
    fld DWORD PTR [esi+16]
    fstp x3
    
    fld DWORD PTR [esi+20]
    fstp y3
    ret
LoadReal4ToBuffer ENDP

LoadReal8ToBuffer PROC
    fld QWORD PTR [esi]
    fstp x1
    
    fld QWORD PTR [esi+8]
    fstp y1
    
    fld QWORD PTR [esi+16]
    fstp x2
    
    fld QWORD PTR [esi+24]
    fstp y2
    
    fld QWORD PTR [esi+32]
    fstp x3
    
    fld QWORD PTR [esi+40]
    fstp y3
    ret
LoadReal8ToBuffer ENDP

LoadReal10ToBuffer PROC
    fld TBYTE PTR [esi]
    fstp x1
    
    fld TBYTE PTR [esi+10]
    fstp y1
    
    fld TBYTE PTR [esi+20]
    fstp x2
    
    fld TBYTE PTR [esi+30]
    fstp y2
    
    fld TBYTE PTR [esi+40]
    fstp x3
    
    fld TBYTE PTR [esi+50]
    fstp y3
    ret
LoadReal10ToBuffer ENDP

CheckTriangleDet PROC
    fld y2
    fld y3
    fsubp
    fld x1
    fmulp
    
    fld y3
    fld y1
    fsubp
    fld x2
    fmulp
    faddp
    
    fld y1
    fld y2
    fsubp
    fld x3
    fmulp
    faddp
    
    ftst
    fstsw ax
    sahf
    
    jz not_triangle
    
is_triangle:
    mov eax, 1
    jmp check_done
    
not_triangle:
    mov eax, 0
    
check_done:
    ffree st(0)
    ret
CheckTriangleDet ENDP

END start