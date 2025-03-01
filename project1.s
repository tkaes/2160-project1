.globl main
.equ STDOUT, 1
.equ STDIN, 0
.equ __NR_READ, 63
.equ __NR_WRITE, 64
.equ __NR_EXIT, 93

.text
main:
    # main() prolog
    addi sp, sp, -104
    sw ra, 100(sp) # Store ra with space for array

    # main() body
    # Call to write_string
    la a0, prompt               # a0 = prompt address
    la a1, prompt_end - prompt  # a1 = prompt length
    jal write_string

    # Call to read_string
    jal read_string

    # Call to write_string
    mv a1, a0               # a1 = prompt length
    lw a0, 0(sp)               # a0 = prompt (array from sp)
    jal write_string        # Call write_string function

    # main() epilog
    lw ra, 100(sp)
    addi sp, sp, 104
    ret

write_string:
    li a7, __NR_WRITE      # a7 = write
    li a0, STDOUT          # a0 = stdout
    mv a2, a1       	   # a2 = prompt length
    mv a1, a0              # a1 = prompt address
    ecall
    ret

read_string:
    li a7, __NR_READ       # a7 = read
    li a0, STDIN           # a0 = stdin
    la a1, 0(sp)           # a1 = prompt address
    addi a2, x0, 100       # a2 = prompt length (max 100)
    ecall
    ret

.data
prompt:   .ascii  "Enter a message: "
prompt_end:
