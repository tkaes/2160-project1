.globl main
.globl getchar
.globl putchar
.equ STDOUT, 1
.equ STDIN, 0
.equ __NR_READ, 63
.equ __NR_WRITE, 64
.equ __NR_EXIT, 93

.text
main:
    # Call to getchar(buf)
    la a0, buf                      # a0 = ADDR of buf
    call getchar

    # Call to putchar(buf)
    la a0, buf                      # a0 = ADDR of buf
    call putchar

    # Exit
    ret
    
getchar:
    mv a1, a0                          # a1 = ADDR of buf
    li a0, STDIN                       # a0 = stdin
    li a2, 1                           # a2 = length (1 char)
    li a7, __NR_READ                   # a7 = read
    ecall
    blt a0, zero, EOF_ERR_LOOP         # if returned a0 < 0, go to err loop
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
    ret

.data
prompt: .ascii "Enter a message: "
prompt_end:
buf: .space 100
