bits 16
org 100h
jmp start
playerX dw 0
playerY dw 0
gravity dw 1
yVelocity dw 0
groundY dw 172;      the ground position--------adjust according to height increase means down. decreasing it means up
jmpStrength dw -15
is_Jumping dw 0
buffer times 64000 db 0
start:
    mov ax,cs;no purpose just for explicit initilailzation
    mov ds,ax
    call initializeGraphics

main:
    call readKey
    call applyGravity
    call clearBuffer
    call displayShape
    call presentFrame
    ;further functions
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
    cmp ah, 01h
    jne notEsc
    jmp near end

notEsc:
    
    cmp ah,48h
    je moveUp
    cmp ah,4Bh
    je moveLeft
    cmp ah,4Dh
    je moveRight
    jmp done

    moveUp:;if upKey pressed and on ground
        cmp word [is_Jumping],1
        je done
        cmp word [playerY],0
        je done
        mov bx,[groundY]
        sub bx,14;----------------------------adjust accordingly
        cmp [playerY],bx        
        jne done
        mov ax,[jmpStrength]
        mov [yVelocity],ax
        mov word [is_Jumping],1
        jmp done

    moveLeft:
        cmp word [playerX], 0
        jle done
        sub word [playerX], 1
        jmp done

    moveRight:
        cmp word [playerX], 312
        jge done
        add word [playerX], 1
        jmp done
    done:
        ret
applyGravity:
    mov bx,[gravity]
    add [yVelocity],bx
    mov bx,[yVelocity]
    add [playerY],bx

    mov bx,[groundY];
    sub bx,14--------------------   adjust accordingly

    cmp [playerY],bx;if playerY<=groundValue------------------------------
    jl stillInAir
    mov word [is_Jumping],0
    mov [playerY],bx
    mov word [yVelocity],0
    jmp done_it
    stillInAir:
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