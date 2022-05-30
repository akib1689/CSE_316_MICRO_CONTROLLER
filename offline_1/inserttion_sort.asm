.model small
.stack 100h
.data
    cr equ 0dh
    lf equ 0ah

    nl db cr,lf,'$'

    n dw ?
    arr dw 100 dup(0)
    error_msg db "please enter a number: $"

.code
;main function
main PROC
    ;init data
    mov ax, @data
    mov ds, ax
    lea si, arr

    
    
    mov ah, 9
    mov dl, offset error_msg
    int 21h
    mov bx, 0

    ;take input n
    start_n:
        mov ah, 1
        int 21h
        ;now the number is in al
        cmp al, cr
        je end_n
        cmp al, lf
        je end_n
        
        ;now al has proper value
        mov ah, 0
        sub al, '0'
        mov cx, ax  ;save the value  to cx
        mov ax, 10
        mul bx
        add ax, cx
        mov bx, ax
        jmp start_n
    end_n:
    mov n, bx
    mov cx, bx

    ;print line feed
    mov ah, 2
    mov dl, lf
    int 21h

    
    top:
        push cx
        mov bx, 0
            start_n_arr:
            ;take the input
            mov ah, 1
            int 21h
            ;now the number is in al
            cmp al, cr
            je end_n_arr
            cmp al, lf
            je end_n_arr
            
            ;now al has proper value
            mov ah, 0
            sub al, '0'
            mov cx, ax  ;save the value  to cx
            mov ax, 10
            mul bx
            add ax, cx
            mov bx, ax
            jmp start_n_arr
            end_n_arr:
        pop cx
        mov dx, n
        sub dx, cx
        xchg dx, bx
        add bx, bx
        mov arr[bx], dx
        ; add si, dx
        ; mov [si], bx
        ; sub si,dx
        ; mov [si], bx
        ; add si, 2
        ;print line feed
        mov ah, 2
        mov dl, lf
        int 21h 
        ; pop cx
    loop top
    
    mov cx, n
    lea si, arr
    insertion_sort_loop_top:
        push cx
        dec cx
        mov bx, n
        sub bx, cx  ;bx-> i=1 to n
        mov dx, bx  
        dec dx      ;dx = bx - 1
        add bx, bx
        mov ax, arr[bx]
        inner_loop_top:
            mov bx, dx
            add bx, bx
            mov cx, arr[bx]
            cmp cx, ax
            jng inner_loop_exit
            cmp dx, 0
            je inner_loop_exit
            dec dx
            jnz inner_loop_top
        inner_loop_exit:
        mov bx, dx
        add bx, 1
        add bx, bx
        mov arr[bx], ax
        pop cx
    loop insertion_sort_loop_top

    ;return to dos
    mov ah, 4ch
    int 21h
main ENDP
end main