TARGET      := 
CC          := gcc
AS          := as
LD          := ld

CFLAGS      := -std=gnu11 -ffreestanding -fno-stack-protector -fno-pie \
               -fno-pic -m32 -Wall -Wextra -Werror -O2

ASFLAGS     := --32

LDFLAGS     := -m elf_i386 -T src/linker.ld -nostdlib

BUILD_DIR   := build
ISO_DIR     := $(BUILD_DIR)/isofiles
KERNEL      := $(BUILD_DIR)/kernel.elf
ISO         := $(BUILD_DIR)/nelos-aula1.iso

OBJECTS     := $(BUILD_DIR)/boot.o $(BUILD_DIR)/kernel.o

.PHONY: all run debug clean check

all: $(ISO)

$(BUILD_DIR)/boot.o: src/boot.s
	mkdir -p $(BUILD_DIR)
	$(AS) $(ASFLAGS) $< -o $@

$(BUILD_DIR)/kernel.o: src/kernel.c
	mkdir -p $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(KERNEL): $(OBJECTS) src/linker.ld
	$(LD) $(LDFLAGS) $(OBJECTS) -o $@

check: $(KERNEL)
	grub-file --is-x86-multiboot2 $(KERNEL)

$(ISO): check iso/boot/grub/grub.cfg
	mkdir -p $(ISO_DIR)/boot/grub
	cp $(KERNEL) $(ISO_DIR)/boot/kernel.elf
	cp iso/boot/grub/grub.cfg $(ISO_DIR)/boot/grub/grub.cfg
	grub-mkrescue -o $@ $(ISO_DIR)

run: $(ISO)
	SDL_VIDEODRIVER=wayland qemu-system-i386 -cdrom $(ISO) -display sdl

debug: $(ISO)
	qemu-system-i386 -cdrom $(ISO) -s -S

clean:
	rm -rf $(BUILD_DIR)