.model small
.stack 100h
.data
    lf equ 0ah
    cr equ 0dh
    a dw ?
    b dw ?
    c dw ?
    three db "three sides equal$"
    two db "two sides equal$"
    no db "no sides equal$"
.code
;main function
main PROC
    ;init data
    mov ax, data
    mov ds, ax
    
    ;take input n
    start_a_n:
        mov ah, 1
        int 21h
        ;now the number is in al
        cmp al, cr
        je end_a_n
        cmp al, lf
        je end_a_n
        
        ;now al has proper value
        mov ah, 0
        sub al, '0'
        mov cx, ax  ;save the value  to cx
        mov ax, 10
        mul bx
        add ax, cx
        mov bx, ax
        jmp start_a_n
    end_a_n:
    mov a, bx
    mov bx, 0

    ;print line feed
    mov ah, 2
    mov dl, lf
    int 21h

    start_b_n:
        mov ah, 1
        int 21h
        ;now the number is in al
        cmp al, cr
        je end_b_n
        cmp al, lf
        je end_b_n
        
        ;now al has proper value
        mov ah, 0
        sub al, '0'
        mov cx, ax  ;save the value  to cx
        mov ax, 10
        mul bx
        add ax, cx
        mov bx, ax
        jmp start_b_n
    end_b_n:
    mov b, bx
    mov bx, 0

    ;print new line
    mov ah, 2
    mov dl, lf ;ASCII or character to be printed
    int 21h


    start_c_n:
        mov ah, 1
        int 21h
        ;now the number is in al
        cmp al, cr
        je end_c_n
        cmp al, lf
        je end_c_n
        
        ;now al has proper value
        mov ah, 0
        sub al, '0'
        mov cx, ax  ;save the value  to cx
        mov ax, 10
        mul bx
        add ax, cx
        mov bx, ax
        jmp start_c_n
    end_c_n:
    mov c, bx
    mov bx, 0

    ;print new line
    mov ah, 2
    mov dl, lf ;ASCII or character to be printed
    int 21h

    ;compare a,b
    mov bx, b
    mov ax, a
    mov cx, c

    cmp ax, bx
    jne ax_bx_else
        ;ax == bx
        cmp ax, cx
        jne ax_cx_else
            ;ax == bx && ax == cx
            MOV DL, offset three
            MOV AH, 9
            INT 21H
            jmp end_if
        ax_cx_else:
            ;ax==bx && ax != cx -> bx !=cx
            MOV DL, offset two
            MOV AH, 9
            INT 21H
            jmp end_if
    ax_bx_else:
        ;ax != bx
        cmp ax, cx
        jne bx_cx_cmp
            ;ax!=bx && ax == cx
            MOV DL, offset two
            MOV AH, 9
            INT 21H
            jmp end_if
        bx_cx_cmp:
            ;ax != cx
            cmp bx, cx
            jne one
                MOV DL, offset two
                MOV AH, 9
                INT 21H
                jmp end_if
            one:
                ;bx != cx
                MOV DL, offset no
                MOV AH, 9
                INT 21H
                jmp end_if   
        
    end_if:
    ;return to dos
    mov ah, 4ch
    int 21h

main ENDP
end main