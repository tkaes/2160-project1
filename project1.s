.globl main
.globl write_string
.globl read_string
.equ STDOUT, 1
.equ STDIN, 0
.equ __NR_READ, 63
.equ __NR_WRITE, 64
.equ __NR_EXIT, 93

.text
main:
    # main() prolog

    # main() body
    # Call to write_string
    la a0, prompt               # a0 = prompt address
    la a1, prompt_end - prompt  # a1 = prompt length
    call write_string

    # Call to read_string
    call read_string

    # Call to write_string
    la a0, buf               # a0 = prompt address (from buf)
    mv a1, a2                # a1 = prompt length (from read_string return)
    call write_string        # Call write_string function

    # main() epilog
    ret

write_string:
    mv a2, a1       	   # a2 = prompt length
    mv a1, a0              # a1 = prompt address
    
    li a7, __NR_WRITE      # a7 = write
    li a0, STDOUT          # a0 = stdout
    ecall
    ret

read_string:
    li a2, buf_end - buf       # a2 = length to read
    la a1, buf                 # a1 = prompt address (from buf)
    
    li a7, __NR_READ       # a7 = read
    li a0, STDIN           # a0 = stdin
    ecall
    ret

.data
prompt:   .ascii  "Enter a message: "
prompt_end:
buf: .space 100
buf_end:
