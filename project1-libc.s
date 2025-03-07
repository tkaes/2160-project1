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
    # Write prompt
    la a0, prompt           # a0 = ADDR of prompt
    call puts
    
    # Call to gets(buf)
    la a0, buf              # a0 = ADDR of buf
    call gets

    # Call to puts(buf)
    la a0, buf              # a0 = ADDR of buf
    call puts

    # Exit
    ret

gets:
    # a0 = ADDR of prompt
    li t0, 0                       # t0 = char c (0)
GETCHAR_LOOP:
    call getchar
    bltz a0, EOF_LOOP              # if a0 = 0, goto EOF
    li t1, NEWLINE                 # t1 = newline
    beq a0, t1, NEWLINE_LOOP       # if a0 = t1, goto NEWLINE
    addi a0, a0, 1                 # increment a0
    jal GETCHAR_LOOP
NEWLINE_LOOP:
    mv a0, t1                      # a0 = newline
    call putchar
    ret
EOF_LOOP:
    li a0, -1                      # a0 = -1
    ret

puts:
    # a0 = ADDR of prompt
    li t0, 0                   # t0 = char c (0)
PUTS_LOOP:
    lb t0, 0(a0)               # t0 = first char in string
    call putchar
    bltz a0, ERR_LOOP          # if a0 = 0, goto ERR
    addi a0, a0, 1             # increment a0
    jal PUTS_LOOP
ERR_LOOP:
    li a0, -1                  # a0 = -1
    ret
DONE:
   li a0, NEWLINE              # a0 = newline
   call putchar
   ret
    
getchar:
    mv a1, a0                          # a1 = ADDR of buf
    li a0, STDIN                       # a0 = stdin
    li a2, 1                           # a2 = length (1 char)
    li a7, __NR_READ                   # a7 = read
    ecall
    blt a0, zero, EOF_ERR_LOOP         # if returned a0 < 0, go to err loop
    lb a0, 0(a1)                       # a0 = returned value from ecall
    ret
EOF_ERR_LOOP:
    li a0, -1                          # a0 = -1
    ret

putchar:    
    mv a1, a0                          # a1 = ADDR of buf
    li a0, STDOUT                      # a0 = stdout
    li a2, 1                           # a2 = length (1 char)
    li a7, __NR_WRITE                  # a7 = write
    ecall
    mv a0, a1                          # a0 = returned value from ecall
    ret

.data
prompt: .ascii "Enter a message: "
prompt_end:
buf: .space 100
