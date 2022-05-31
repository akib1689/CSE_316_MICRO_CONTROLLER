.model small
.stack 100h
.data
    cr equ 0dh
    lf equ 0ah
    size_msg db "size of the array: $"
    prompt_msg db "the numbers: $"
    search_msg db "number to search: $"
    success_msg db "found position: $"
    fail_msg db "not found$"
    nl db cr,lf,'$'
    n dw ?
    search_val dw ?
    higher dw ?
    lower dw ?
    mid dw ?
    arr dw 20 dup(0)
.code
;main function
main PROC
    ;init data
    mov ax, @data
    mov ds, ax
    lea si, arr

    
    
    mov ah, 9
    mov dx, offset size_msg
    int 21h
    xor bx, bx

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
        and ax, 000fh
        mov cx, ax  ;save the value  to cx
        mov ax, 10
        mul bx
        add ax, cx
        mov bx, ax
        jmp start_n
    end_n:
    mov n, bx

    ;print line feed
    mov ah, 2
    mov dx, lf
    int 21h

    ;print prompt message
    mov ah, 9
    mov dx, offset prompt_msg
    int 21h
    
    ;this takes n numbers
    mov cx, n
    top:
        push cx
        xor bx, bx
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
            and ax, 000fh
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
        ;print line feed
        mov ah, 2
        mov dx, lf
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

            cmp dx, 0
            jnge inner_loop_exit

            mov bx, dx
            add bx, bx
            mov cx, arr[bx]

            
            cmp cx, ax
            jng inner_loop_exit

            
            
            
            inc dx
            mov bx, dx
            add bx, bx
            mov arr[bx], cx
            dec dx
            dec dx
            jmp inner_loop_top
        inner_loop_exit:
        mov bx, dx
        add bx, 1
        add bx, bx
        mov arr[bx], ax
        pop cx
        dec cx
        cmp cx, 1
    jnle insertion_sort_loop_top


    ;print line feed
    mov ah, 2
    mov dx, lf
    int 21h

    ;print prompt message
    mov ah, 9
    mov dx, offset search_msg
    int 21h

    ;now the arr is sorted
    xor bx, bx

    ;take input search_val
    start_search:
        mov ah, 1
        int 21h
        ;now the number is in al
        cmp al, cr
        je end_search
        cmp al, lf
        je end_search
        
        ;now al has proper value
        and ax, 000fh
        mov cx, ax  ;save the value  to cx
        mov ax, 10
        mul bx
        add ax, cx
        mov bx, ax
        jmp start_search
    end_search:
    mov search_val, bx
    
    ;print line feed
    mov ah, 2
    mov dx, lf
    int 21h

    ;initialize
    ;cx -> lower
    ;dx -> higher
    ;ax -> used for the array element 
    xor cx, cx
    mov lower, cx
    mov dx, n
    dec dx
    mov higher, dx

    search_top:
        mov cx, lower
        mov dx, higher
        cmp cx, dx
        jnle not_found_in_search
            ;calculate mid
            ;use bx to find the mid
            mov bx, cx 
            add bx, dx  ;bx = lower + higher
            shr bx,1    ;bx = bx/2

            ;now access the bx element in the array
            add bx, bx
            mov ax, arr[bx]
            cmp ax, search_val
            je found_in_search
            jg left_pivot_bin_search
            jmp right_pivot_bin_search 

        right_pivot_bin_search:
            shr bx, 1
            inc bx
            mov lower, bx
            jmp search_top
        left_pivot_bin_search:
            shr bx,1
            dec bx
            mov higher, bx
            jmp search_top 

        found_in_search:
            ;bx has 2 * the index
            shr bx, 1
            ;print msg
            mov dx, offset success_msg
            mov ah, 9
            int 21h

            ;print the index
            mov dx, bx
            add dx, '0'
            mov ah, 2
            int 21h


            jmp end_bin_search
        not_found_in_search:
            mov dx, offset fail_msg
            mov ah, 9
            int 21h
            jmp end_bin_search
    end_bin_search:
        ;not found
    ;return to dos
    mov ah, 4ch
    int 21h
main ENDP
end main