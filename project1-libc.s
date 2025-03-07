.globl main
.globl getchar
.globl putchar
.globl gets
.globl puts
.equ STDOUT, 1
.equ STDIN, 0
.equ __NR_READ, 63
.equ __NR_WRITE, 64
.equ __NR_EXIT, 93
.equ NEWLINE, 10

.text
main:
    # main body
    # write prompt
    la a0, prompt           # a0 = ADDR of prompt
    la a1, prompt_end
    call puts
    # call to gets(buf)
    la a0, buf              # a0 = ADDR of buf
    la a1, buf_end
    call gets
    # call to puts(buf)
    la a0, buf              # a0 = ADDR of buf
    la a1, buf_end
    call puts
    # main epilog
    j halt
halt:
    ebreak
    j halt

gets:
    # a0 = ADDR of prompt
    li t0, 0                        # t0 = char c (0)
GETS_LOOP:
    call getchar
    bltz a0, GETS_DONE              # if a0 = 0, goto DONE
    li t1, NEWLINE                  # t1 = newline
    beq a0, t1, GETS_NEWLINE        # if a0 = t1, goto NEWLINE
    addi a0, a0, 1                  # increment a0
    jal GETS_LOOP
GETS_NEWLINE:
    mv a0, t1                       # a0 = newline
    call putchar
    ret
GETS_DONE:
    li a0, -1                       # a0 = -1
    ret

puts:
    # puts prolog
    addi sp, sp, -4
    sw ra, 0(sp)                    # store ra
    # puts body
    mv s0, a0                       # s0 = string pointer (from a0)
    mv s1, a1                       # a1 = string end (from a1)
    li t0, -1                       # t0 = err indicator
PUTS_LOOP:
    lbu a0, 0(s0)                   # a0 = load from string pointer
    beq a0, t0, PUTS_ERR            # if a0 = err, go to ERR
    beqz a0, PUTS_NEWLINE           # if a0 = 0, go to NEWLINE
    call putchar
    addi s0, s0, 1                  # increment string pointer
    jal PUTS_LOOP
PUTS_ERR:
    li a0, -1                       # a0 = -1
    ret
PUTS_NEWLINE:
    li a0, NEWLINE                  # a0 = newline
    call putchar
    li a0, 0                        # a0 = success
    jal PUTS_DONE
    # puts epilog
PUTS_DONE:
    lw ra, 0(sp)                    # restore stack
    addi sp, sp, 4
    ret
    
getchar:
    mv a1, a0                       # a1 = ADDR of buf
    li a0, STDIN                    # a0 = stdin
    li a2, 1                        # a2 = length (1 char)
    li a7, __NR_READ                # a7 = read
    ecall
    blt a0, zero, EOF_ERR_LOOP      # if returned a0 < 0, go to err loop
    lb a0, 0(a1)                    # a0 = returned value from ecall
    ret
EOF_ERR_LOOP:
    li a0, -1                       # a0 = -1
    ret

putchar:  
    # putchar prolog
    addi sp, sp, -8
    sw ra, 4(sp)                    # store ra
    sw s0, 0(sp)                    # store string pointer from puts
    # putchar body
    mv s0, a0                       # s0 = passed char
    li a0, STDOUT                   # a0 = stdout
    li a2, 1                        # a2 = length (1 char)
    li a7, __NR_WRITE               # a7 = write
    addi sp, sp, -1                 # add 1 byte to stack
    sb s0, 0(sp)                    # store passed char
    mv a1, sp                       # a1 = address where char is stored
    ecall
    lbu a0, 0(sp)                   # a0 = passed char
    addi sp, sp, 1                  # restore stack
    # putchar epilog
    lw s0, 0(sp)                    # load original s0 (string pointer)
    lw ra, 4(sp)                    # load original ra
    addi sp, sp, 8
    ret

.data
prompt: .ascii "Enter a message: "
prompt_end:
buf: .space 100
buf_end:
