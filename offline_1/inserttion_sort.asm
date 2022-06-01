.model small
.stack 100h
.data
    cr equ 0dh
    lf equ 0ah
    size_msg db "size of the array: $"
    prompt_msg db "enter the numbers: $"
    sorted_msg db "the sorted array is: $"
    search_msg db "number to search: $"
    success_msg db "found position: $"
    fail_msg db "not found$"
    nl db cr,lf,'$'
    number_str db "00000$"
    n dw ?
    search_val dw ?
    higher dw ?
    lower dw ?
    arr dw 20 dup(0)
    flag db 0
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

                                    
    call take_input                     ;take input to bx
    cmp bx, 0
    jle end_main                        ;if 0, end
    mov n, bx                           ;n = bx

    ;print line feed
    mov ah, 2
    mov dx, lf
    int 21h

    ;print prompt message
    mov ah, 9
    mov dx, offset prompt_msg
    int 21h
    mov dx, offset nl
    int 21h
    
    ;this takes n numbers
    mov cx, n
    top:
        push cx                         ;save cx i for later
        
        call take_input                 ;take input to cx
        
        pop cx                          ;cx = i
        
        ;find the index of the number
        mov dx, n                       ;dx = n
        sub dx, cx                      ;dx = n - i
        xchg dx, bx                     ;bx = n - i and dx = taken input
        add bx, bx                      ;bx = 2 * (n - i)
        mov arr[bx], dx                 ;arr[n - i] = taken input
        ;print line feed
        mov ah, 2
        mov dx, lf
        int 21h
    loop top
    
    ;sort the array using insertion sort
    call insertion_sort

    ;print sorted array message
    mov ah, 9
    mov dx, offset sorted_msg
    int 21h
    mov dx, offset nl
    int 21h

    mov cx, n                           ;cx = n
    print_top:
        push cx                         ;save cx i for later
        ;find the index of the number
        mov bx, n                       ;bx = n
        sub bx, cx                      ;bx = n - i
        add bx, bx                      ;bx = 2 * (n - i)
        mov ax, arr[bx]                 ;ax = arr[n - i] 
                                        ;as the value is word we need to multiply bx twice
        call print_integer              ;print the number
        mov ah, 2
        mov dl, ' '
        int 21h
        pop cx                          ;cx = i
        loop print_top

    ;binary search jump point
    binary_search_jmp:
        ;while(1)
        ;print new line                 
        mov ah, 2
        mov dx, lf
        int 21h
        mov dx, cr
        int 21h
        ;print 
        
        

        ;print prompt message
        mov ah, 9
        mov dx, offset search_msg
        int 21h

        ;now the arr is sorted
        xor bx, bx

        ;take input search_val
        call take_input
        mov search_val, bx          ;search_val = bx = taken input
        
        ;print line feed
        mov ah, 2
        mov dx, lf
        int 21h


        ;find the position of the search_val in the array using binary search
        call bin_search
    jmp binary_search_jmp            ;jump to binary search
      
    ;return to dos
    mov ah, 4ch
    int 21h
main ENDP

;sorts the array using insertion sort
insertion_sort PROC
    mov cx, n
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
            
            ;compare the value at arr[dx] with the value at arr[dx+1]
            mov bx, dx
            add bx, bx
            mov cx, arr[bx]
            cmp cx, ax
            ;if arr[dx] > arr[dx+1]
            jng inner_loop_exit
            ;swap
            

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

    ret    
insertion_sort ENDP

;binary search on sorted array arr
bin_search PROC
    ;initialize the variables lower and higher to cx an
    ;cx -> lower
    ;dx -> higher
    ;ax -> used for the array element to be searched
    xor cx, cx          ;make cx zero
    mov lower, cx       ;save the value of cx to lower
    mov dx, n           ;make dx n
    dec dx              ;make dx n-1
    mov higher, dx      ;save the value of dx to higher


    search_top:
        ;initialize the variables lower and higher to cx and dx
        mov cx, lower                   ;cx = lower
        mov dx, higher                  ;dx = higher
        cmp cx, dx                      ;if cx > dx
        jnle not_found_in_search        ;jump to not_found_in_search
            ;calculate mid
            ;use bx to find the mid
            mov bx, cx                  ;bx = cx
            add bx, dx                  ;bx = lower + higher
            shr bx,1                    ;bx = bx/2

            ;now access the bx element in the array
            add bx, bx                  ;bx = bx*2
            mov ax, arr[bx]             ;ax = arr[bx]
            cmp ax, search_val          ;compare ax with search_val
            je found_in_search          ;if ax == search_val
            jg left_pivot_bin_search    ;if ax > search_val
            jmp right_pivot_bin_search  ;if ax < search_val

        right_pivot_bin_search:
            shr bx, 1                   ;bx = bx/2
            inc bx                      ;bx = bx + 1
            mov lower, bx               ;lower = bx
            jmp search_top              ;jump to search_top
        left_pivot_bin_search:
            shr bx,1                    ;bx = bx/2
            dec bx                      ;bx = bx - 1
            mov higher, bx              ;higher = bx
            jmp search_top              ;jump to search_top

        found_in_search:
            ;bx has 2 * the index
            shr bx, 1                   ;bx = bx/2
            ;print msg
            mov dx, offset success_msg  
            mov ah, 9                   
            int 21h                     

            ;print the index
            mov ax, bx              ;ax = bx = o based indexing
            inc ax                  ;ax = bx + 1 now it has 1 based indexing
            call print_integer      ;print the index of the number in integer form
            jmp end_bin_search      ;jump to end_bin_search
        not_found_in_search:
            ;not found
            mov dx, offset fail_msg
            mov ah, 9
            int 21h
            jmp end_bin_search
    end_bin_search:
    ret
bin_search ENDP

;this function takes the integer input from the user to bx
take_input PROC
    xor bx, bx                          ;make bx zero
    mov flag, 0                         ;make flag zero
    mov ah, 1
    int 21h
    cmp al, '-'                         ;if al is '-'
    jne no_minus                        ;jump to no_minus
    ;if al is '-'
    mov flag, -1
    jmp start_n
    no_minus:
        ;if al is not '-' add the value of al to bx in decimal form
        and ax, 000fh                   ;make ax contain the decimal interpretation of al
            mov cx, ax                      ;save the value  to cx
            mov ax, 10                      ;make ax 10
            mul bx                          ;bx = bx * 10
            add ax, cx                      ;bx = bx + cx
            mov bx, ax
        start_n:
            mov ah, 1                       ;get the input
            int 21h
            ;now the number is in al
            cmp al, cr                      ;if al == cr
            je end_n                        ;jump to end_n
            cmp al, lf                      ;if al == lf
            je end_n                        ;jump to end_n
            
            ;now al has proper value
            and ax, 000fh                   ;make ax contain the decimal interpretation of al
            mov cx, ax                      ;save the value  to cx
            mov ax, 10                      ;make ax 10
            mul bx                          ;bx = bx * 10
            add ax, cx                      ;bx = bx + cx
            mov bx, ax                      ;save the value of ax to bx
            jmp start_n                     ;jump to start_n
        end_n:
            ;check if the value of dx is -1
            cmp flag, -1
            je negative_number
            jmp positive_number
        negative_number:
            ;if the value of dx is -1
            ;make bx negative
            neg bx
            jmp end_take_input
        positive_number:
            ;if the value of dx is not -1
            ;make bx positive
            jmp end_take_input
    end_take_input:
    
    ret                                 ;return to caller
take_input ENDP

;this function prints the integer value specified by ax
print_integer PROC
    ;compare if the value of ax is less than zero
    cmp ax, 0
    jge pos_number
    ;if the value of ax is less than zero
    ;make ax positive
    ;print character '-'
    mov cx, ax              ;save the value of ax to cx
    mov ah, 2
    mov dl, '-'
    int 21h
    mov ax, cx              ;restore the value of ax to cx
    neg ax
    pos_number:
        lea si, number_str
        add si, 5
        print_loop:
            dec si
            xor dx, dx
            mov cx, 10
            div cx
            add dl, '0'
            mov [si], dl
            cmp ax, 0
            jne print_loop

    ;print the string
    mov ah, 9
    mov dx, si
    int 21h
    ret
    
print_integer ENDP
end main