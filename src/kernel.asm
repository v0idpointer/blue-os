[BITS 16]

mov word ax, 0x1000
mov word ds, ax

call disable_cursor
call clear

pusha
mov si, szWindows
mov byte ch, 0x23
mov byte cl, 0x08
call printex
popa

pusha
mov si, szMessage1
mov byte ch, 0x08
mov byte cl, 0x0A
call print
popa

pusha
mov si, szMessage2
mov byte ch, 0x08
mov byte cl, 0x0B
call print
popa

pusha
mov si, szInstruction1
mov byte ch, 0x08
mov byte cl, 0x0D
call print
popa

pusha
mov si, szInstruction2
mov byte ch, 0x08
mov byte cl, 0x0E
call print
popa

pusha
mov si, szInstruction3
mov byte ch, 0x08
mov byte cl, 0x0F
call print
popa

pusha
mov si, szPressAnyKey
mov byte ch, 0x1A
mov byte cl, 0x11
call print
popa

jmp $

%include "src\text.asm"

clear:
    pusha
    
    mov word cx, 0x0000
    mov word dx, 0x07FF
    mov word bx, 0xB800
    mov word es, bx
    mov word bx, 0x0000

    .clear_loop:
        cmp cx, dx
        je .clear_finish
        mov byte [es:bx], ' '
        inc bx
        mov byte [es:bx], 0x1F
        inc bx
        inc cx
        jmp .clear_loop

    .clear_finish:
        popa
        ret

disable_cursor:
    pusha
    mov byte ah, 0x02
    mov byte bh, 0x00
    mov byte dh, 0xFF
    mov byte dl, 0xFF
    int 0x10
    popa
    ret

print:
    mov word bx, 0xB800
    mov word es, bx
    mov word bx, 0x0000

    mov byte dh, 0x00
    mov byte dl, ch
    add bx, dx
    add bx, dx

    mov byte dh, 0x00
    mov byte dl, cl

    mov word cx, 0x0000
    .print_line_counter:
        cmp cx, dx
        je .print_loop
        add bx, 0xA0
        inc cx
        jmp .print_line_counter

    .print_loop:
        lodsb
        cmp al, 0x00
        jz .print_finish

        mov byte [es:bx], al
        inc bx
        mov byte [es:bx], 0x17
        inc bx

        jmp .print_loop

    .print_finish:
        ret

printex:
    mov word bx, 0xB800
    mov word es, bx
    mov word bx, 0x0000

    mov byte dh, 0x00
    mov byte dl, ch
    add bx, dx
    add bx, dx

    mov byte dh, 0x00
    mov byte dl, cl

    mov word cx, 0x0000
    .printex_line_counter:
        cmp cx, dx
        je .printex_loop
        add bx, 0xA0
        inc cx
        jmp .printex_line_counter

    .printex_loop:
        lodsb
        cmp al, 0x00
        jz .printex_finish

        mov byte [es:bx], al
        inc bx
        mov byte [es:bx], 0x71
        inc bx

        jmp .printex_loop

    .printex_finish:
        ret