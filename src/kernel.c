typedef unsigned char uint8_t;
typedef unsigned short uint16_t;
typedef unsigned int uint32_t;

#define VGA_ADDRESS 0xB8000
#define VGA_WIDTH 80
#define VGA_HEIGHT 25
#define VGA_COLOR 0x0F
#define WHITE_ON_BLACK 0x0F

static uint16_t* const vga_buffer = (uint16_t*) VGA_ADDRESS;

void vga_clear(void) {
    for (int i=0; i < VGA_WIDTH * VGA_HEIGHT; i++) {
        vga_buffer[i] = (uint16_t)' ' | ((uint16_t)WHITE_ON_BLACK << 8);
    }
}

static void vga_write(const char* text, uint32_t row)
{
    volatile uint16_t* const vga = (volatile uint16_t*)VGA_ADDRESS;
    uint32_t column = 0;

    while (*text != '\0' && column < VGA_WIDTH) {
        vga[row * VGA_WIDTH + column] = ((uint16_t)VGA_COLOR << 8) | (uint8_t)*text;

        ++text;
        ++column;
    }
}

void kernel_main(void)
{
    vga_clear();
    
    vga_write("NelOS - Aula 1", 0);
    vga_write("GRUB carregou o kernel em C.", 1);
    vga_write("QEMU esta executando nosso codigo.", 2);

    for (;;) {
        __asm__ volatile ("hlt");
    }
}
