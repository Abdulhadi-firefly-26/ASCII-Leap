bits 16
org 100h
jmp start
playerX dw 0
playerY dw 0
buffer times 64000 db 0
start:
    mov ax,cs;no purpose just for explicit initilailzation
    mov ds,ax
    call initializeGraphics

main:
    call readKey
    call clearBuffer
    call displayShape
    call presentFrame
;                collision//first display graphics. if working then later we'll write collision
    jmp main
clearBuffer:
    cld
    push es
    push ds
    pop es
    mov di,buffer
    xor ax, ax
    mov cx, 64000
    cld
    rep stosb
    pop es
    ret

presentFrame:
    push si
    push di
    push cx
    cld
    mov si,buffer
    xor di, di
    mov cx, 64000
    rep movsb
    pop cx
    pop di
    pop si
    ret

clearScreen:
    xor di,di
    xor ax,ax
    mov cx,64000
    rep stosb;  //
    ret
initializeGraphics:
    mov ax,13h
    int 10h
    mov ax,0A000h
    mov es,ax
    ret

readKey:
    mov ah, 01h;       check if key entered to continue it running
    int 16h
    jz done
    mov ah,00
    int 16h
    
    cmp ah,01h        ; ESC scancode
    je end
    cmp ah,48h
    je moveUp
    cmp ah,50h
    je moveDown
    cmp ah,4Bh
    je moveLeft
    cmp ah,4Dh
    je moveRight
    jmp done

    
    moveUp:
        sub word [playerY],1
        jmp done

    moveDown:
        add word [playerY],1
        jmp done

    moveLeft:
        sub word [playerX],1
        jmp done

    moveRight:
        add word [playerX],1
        jmp done

    done:
        ret

displayShape:
    mov bx,0
    rectangle_height:
    mov cx,0
    cmp bx,14;                  height variable y-axis
    jge finished

    rectangle_length:
    cmp cx, 8;                  length variable x-axis
    jge done_length
    mov ax,[playerY]
    add ax, bx
    mov dx,320;                 offset= x-axis+ y-axis*320
    mul dx
    add ax,[playerX]
    add ax,cx
    mov di,ax
   
    mov byte [buffer+di],4
    inc cx
    jmp rectangle_length


    done_length:
        inc bx
        jmp rectangle_height
    
    finished:;                   call output interrup and return
    ret




end:
    mov ax,0003h
    int 10h
    mov ax,4C00h
    int 21h