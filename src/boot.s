.set MULTIBOOT2_MAGIC, 0xe85250d6
.set MULTIBOOT2_ARCH, 0
.set MULTIBOOT2_HEADER_LEN, (multiboot2_end - multiboot2_start)
.set MULTIBOOT2_CHECKSUM, -(MULTIBOOT2_MAGIC + MULTIBOOT2_ARCH + MULTIBOOT2_HEADER_LEN)

.section .multiboot2
.align 8
multiboot2_start:
    .long MULTIBOOT2_MAGIC
    .long MULTIBOOT2_ARCH
    .long MULTIBOOT2_HEADER_LEN
    .long MULTIBOOT2_CHECKSUM

    .short 0
    .short 0
    .long 8
multiboot2_end:

.section .text
.global _start
.extern kernel_main

_start:
    cli
    mov $stack_top, %esp
    xor %ebp, %ebp

    call kernel_main

.hang:
    hlt
    jmp .hang

.section .bss
.align 16
stack_bottom:
    .skip 16384
stack_top:

