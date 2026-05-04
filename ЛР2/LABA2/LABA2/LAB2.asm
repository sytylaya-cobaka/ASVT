
;X=87A3 Y=5322 Z=07F1
;X=1000 0111 1010 0011 Y=0101 0011 0010 0010 Z=0000 0111 1111 0001
;X=34723 Y=21282 Z=2033

;X'= 0111 0000 1111 0100=28916
;Y' = 0100 1010 0110 0100=19044
;Z' = 0010 0000 1111 1110= 8446

;M = X' - Z' + Y'= 28916 - 8446 + 19044 = 20470 + 19044 = 39514(без учета знака)
;M=39514=9A5A=1001 1010 0101 1010

;так как у М самый старшмй бит=1, число отрицательное
;отрц число = -(2^16 - M) = -(65536 - 39514) = -26022
;M=-26022 (с учетом знака)

;так как М отрицательная выполняем вариант2
;R=-M=26022
;R=65A6

;проверяем: Если R>007D
;65A6>007D - правда (26022 > 125)
;значит делаем  АДР1 (R/2)

;R=65A6=0110 0101 1010 0110
;0110 0101 1010 0110 >> 1 =0011 0010 1101 0011=32D3
;26022/2=13011
;32D3=13011

;R = 32D3h = 13011
;--------------------------------------------------------------------------------------------------------------

.386
.MODEL FLAT, STDCALL
.STACK 4096

.DATA
    
    X   DW  87A3h      
    Y   DW  5322h      
    Z   DW  07F1h     
        
    X_prime DW ?
    Y_prime DW ?
    Z_prime DW ?
       
    M       DW ?
    R       DW ?

.CODE

;подпрограмма1 R = M + 5
Subprogram1 PROC
    mov ax, M
    add ax, 5
    mov R, ax
    ret
Subprogram1 ENDP

;подпрограмма2 R = -M
Subprogram2 PROC
    mov ax, M
    neg ax
    mov R, ax
    ret
Subprogram2 ENDP

; Адрес1 R/2
Addr1 PROC
    mov ax, R
    sar ax, 1           ;арифметический сдвиг вправо (для знаковых чисел)
    mov R, ax
    ret
Addr1 ENDP

;Адрес2: R = R OR 17D1h
Addr2 PROC
    mov ax, R
    or ax, 17D1h
    mov R, ax
    ret
Addr2 ENDP

; процедура циклического сдвига вправо на 3 разряда
;навход: AX - число, на выход: AX - результат
RotateRight3 PROC
    push cx
    mov cx, 3
rotate_loop:
    ror ax, 1           ; циклический сдвиг вправо на 1 бит
    loop rotate_loop
    pop cx
    ret
RotateRight3 ENDP

main PROC
    ;  цикл сдвига чисел X, Y, Z 
        
    mov ax, X
    call RotateRight3
    mov X_prime, ax
        
    mov ax, Y
    call RotateRight3
    mov Y_prime, ax
        
    mov ax, Z
    call RotateRight3
    mov Z_prime, ax
    
    ;M = X' - Z' + Y'
    mov ax, X_prime
    sub ax, Z_prime     ; AX = X' - Z'
    add ax, Y_prime     ; AX = X' - Z' + Y'
    mov M, ax
    
    ;проверка знака M и переход к подпрограмме
    cmp M, 0
    jg call_sub1        ; если M > 0, переход к п/п 1
    ; иначе M <= 0, переход к п/п 2
    call Subprogram2    ; R = -M
    jmp check_R         ; переход к проверке R
    
call_sub1:
    call Subprogram1    ; R = M + 5
    jmp check_R
    
    ;проверка R и переход к адр1/2 

check_R:
    cmp R, 007Dh
    jg call_addr1       ; если R > 007Dh-> переход к адр1
    ; иначе переход к АДР2
    call Addr2          ; R = R OR 17D1h
    jmp finish
    
call_addr1:
    call Addr1          ; R = R / 2
    
   
finish:    
    xor eax, eax
    ret
    
main ENDP

END main