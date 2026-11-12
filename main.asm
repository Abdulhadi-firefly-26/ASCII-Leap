section .data
    playerX dw 0
    playerY dw 0

section .text
global start
;                 CURRENTLY have NO END INFINTE. FIX IT as wont read interrupts of exit to display graphic
call initializeGraphics
start:
call readKey
call displayShape
;call collision make its logic. 
jmp start


initializeGraphics:
    mov ax,13h
    int 10h
    mov ax,0A000h
    mov es,ax
    ret

readKey:
    mov ax, 0001;check if key entered; cehck what if we dont write these 2 lines and dont check
    int 16h
    jz done
    mov ax,00
    int 16h

    cmp ah,48h
    je moveUp
    cmp ah,50h
    je moveDown
    cmp ah,4Bh
    je moveLeft
    cmp ah,4Dh
    je moveRight

    moveUp:
        sub [playery],1
        jmp done

    moveDown:
        add [playerY],1
        jmp done

    moveLeft:
        sub [playerX],1
        jmp done

    moveRight:
        add [playerX],1
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
    mov dx,320h;                offset= x-axis+ y-axis*320
    mul dx
    mov di,ax
    add ax,[playerX]
    add ax,cx
    mov di,ax
    mov byte [es:di],4
    inc cx
    jmp rectangle_length

    done_length:
        inc bx
        jmp rectangle_height
    
    finished;                   call output interrup and return
    ret

;collison: 


end:
    mov ax,0003h
    int 10h
    mov ax,4C00h
    int 21h