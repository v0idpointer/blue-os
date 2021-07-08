[BITS 16]

mov word ax, 0x07C0
add word ax, 288
mov word ss, ax
mov word sp, 4096

mov word ax, 0x07C0
mov word ds, ax

mov byte ah, 0x00
mov byte al, 0x03
int 0x10

pusha

mov word bx, 0x1000
mov word es, bx
mov word bx, 0x0000

mov byte ah, 0x02
mov byte al, 0x02
mov byte ch, 0x00
mov byte cl, 0x02
mov byte dh, 0x00
mov byte dl, 0x00

int 0x13

cmp ah, 0x00
je start_kernel
call disk_read_err

popa

call halt

jmp $

szStartupMsg db "Starting...", 0
szSystemHalt db "System halted.", 0
szDiskError db "An error has occurred while reading the disk!", 0

print:
    mov byte ah, 0x0E
    .print_loop:
        lodsb
        cmp al, 0x00
        jz .print_finish
        int 0x10
        jmp .print_loop
    .print_finish:
        ret

println:
    call print
    
    pusha
    mov byte ah, 0x0E
    mov byte al, 0x0D
    int 0x10
    mov byte al, 0x0A
    int 0x10
    popa

    ret

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
        mov byte [es:bx], 0x0F
        inc bx
        inc cx
        jmp .clear_loop

    .clear_finish:
        popa
        ret

halt:
    pusha
    mov si, szSystemHalt
    call print
    popa
    ret

start_kernel:
    jmp 0x1000:0x0000

disk_read_err:
    pusha
    mov si, szDiskError
    call println
    popa
    ret

times 510-($-$$) db 0x00
dw 0xAA55