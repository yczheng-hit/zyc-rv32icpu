CROSS=/opt/riscv32i/bin/riscv32-unknown-elf-
CFLAGS=-march=rv32i -mabi=ilp32 -O0 -g -ffreestanding
LDFLAGS= -Wl,-Bstatic,-T,sections.ld -nostdlib

all: firmware.hex firmware.bin firmware.asm

firmware.elf: start.o firmware.o  uart_api.o math.o
	$(CROSS)gcc $(LDFLAGS) -o $@ $^

%.o: %.c
	$(CROSS)gcc $(CFLAGS) -c $^ -o $@

start.o: start.S
	$(CROSS)gcc $(CFLAGS) -c $^ -o $@

firmware.hex: firmware.elf
	$(CROSS)objcopy -O verilog $< $@

firmware.bin: firmware.elf
	$(CROSS)objcopy -O binary $< $@

firmware.asm: firmware.elf
	$(CROSS)objdump -d $< > $@


clean:
	rm -f *.hex *.elf *.bin *.txt *.o
.PHONY: clean all
