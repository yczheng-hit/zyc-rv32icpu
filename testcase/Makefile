CROSS=/opt/riscv32i/bin/riscv32-unknown-elf-
CFLAGS=-march=rv32i -mabi=ilp32 -ffreestanding -nostdlib -O0 -g

OBJECT-R-TYPE=R_type
OBJECT-I-TYPE=I_type
OBJECT-U-TYPE=U_type
OBJECT-S-TYPE=S_type
OBJECT-B-TYPE=B_type
OBJECT-J-TYPE=J_type

all: $(OBJECT-R-TYPE) $(OBJECT-I-TYPE) $(OBJECT-U-TYPE) $(OBJECT-S-TYPE) $(OBJECT-B-TYPE) $(OBJECT-J-TYPE)
# R
$(OBJECT-R-TYPE): ./$(OBJECT-R-TYPE)/$(OBJECT-R-TYPE).elf ./$(OBJECT-R-TYPE)/$(OBJECT-R-TYPE).hex ./$(OBJECT-R-TYPE)/$(OBJECT-R-TYPE).bin ./$(OBJECT-R-TYPE)/$(OBJECT-R-TYPE).asm
clean-$(OBJECT-R-TYPE): ./$(OBJECT-R-TYPE)/$(OBJECT-R-TYPE).elf ./$(OBJECT-R-TYPE)/$(OBJECT-R-TYPE).hex ./$(OBJECT-R-TYPE)/$(OBJECT-R-TYPE).bin ./$(OBJECT-R-TYPE)/$(OBJECT-R-TYPE).asm
	rm $^

./$(OBJECT-R-TYPE)/$(OBJECT-R-TYPE).elf: sections.ld ./$(OBJECT-R-TYPE)/start.S
	$(CROSS)gcc $(CFLAGS) -Wl,-Bstatic,-T,sections.ld -o $@ ./$(OBJECT-R-TYPE)/start.S

./$(OBJECT-R-TYPE)/$(OBJECT-R-TYPE).hex: ./$(OBJECT-R-TYPE)/$(OBJECT-R-TYPE).elf
	$(CROSS)objcopy -O verilog $< $@

./$(OBJECT-R-TYPE)/$(OBJECT-R-TYPE).bin: ./$(OBJECT-R-TYPE)/$(OBJECT-R-TYPE).elf
	$(CROSS)objcopy -O binary $< $@

./$(OBJECT-R-TYPE)/$(OBJECT-R-TYPE).asm: ./$(OBJECT-R-TYPE)/$(OBJECT-R-TYPE).elf
	$(CROSS)objdump -d $< > $@


# I
$(OBJECT-I-TYPE): ./$(OBJECT-I-TYPE)/$(OBJECT-I-TYPE).elf ./$(OBJECT-I-TYPE)/$(OBJECT-I-TYPE).hex ./$(OBJECT-I-TYPE)/$(OBJECT-I-TYPE).bin ./$(OBJECT-I-TYPE)/$(OBJECT-I-TYPE).asm
clean-$(OBJECT-I-TYPE): ./$(OBJECT-I-TYPE)/$(OBJECT-I-TYPE).elf ./$(OBJECT-I-TYPE)/$(OBJECT-I-TYPE).hex ./$(OBJECT-I-TYPE)/$(OBJECT-I-TYPE).bin ./$(OBJECT-I-TYPE)/$(OBJECT-I-TYPE).asm
	rm $^

./$(OBJECT-I-TYPE)/$(OBJECT-I-TYPE).elf: sections.ld ./$(OBJECT-I-TYPE)/start.S
	$(CROSS)gcc $(CFLAGS) -Wl,-Bstatic,-T,sections.ld -o $@ ./$(OBJECT-I-TYPE)/start.S

./$(OBJECT-I-TYPE)/$(OBJECT-I-TYPE).hex: ./$(OBJECT-I-TYPE)/$(OBJECT-I-TYPE).elf
	$(CROSS)objcopy -O verilog $< $@

./$(OBJECT-I-TYPE)/$(OBJECT-I-TYPE).bin: ./$(OBJECT-I-TYPE)/$(OBJECT-I-TYPE).elf
	$(CROSS)objcopy -O binary $< $@

./$(OBJECT-I-TYPE)/$(OBJECT-I-TYPE).asm: ./$(OBJECT-I-TYPE)/$(OBJECT-I-TYPE).elf
	$(CROSS)objdump -d $< > $@

# U
$(OBJECT-U-TYPE): ./$(OBJECT-U-TYPE)/$(OBJECT-U-TYPE).elf ./$(OBJECT-U-TYPE)/$(OBJECT-U-TYPE).hex ./$(OBJECT-U-TYPE)/$(OBJECT-U-TYPE).bin ./$(OBJECT-U-TYPE)/$(OBJECT-U-TYPE).asm
clean-$(OBJECT-U-TYPE): ./$(OBJECT-U-TYPE)/$(OBJECT-U-TYPE).elf ./$(OBJECT-U-TYPE)/$(OBJECT-U-TYPE).hex ./$(OBJECT-U-TYPE)/$(OBJECT-U-TYPE).bin ./$(OBJECT-U-TYPE)/$(OBJECT-U-TYPE).asm
	rm $^

./$(OBJECT-U-TYPE)/$(OBJECT-U-TYPE).elf: sections.ld ./$(OBJECT-U-TYPE)/start.S
	$(CROSS)gcc $(CFLAGS) -Wl,-Bstatic,-T,sections.ld -o $@ ./$(OBJECT-U-TYPE)/start.S

./$(OBJECT-U-TYPE)/$(OBJECT-U-TYPE).hex: ./$(OBJECT-U-TYPE)/$(OBJECT-U-TYPE).elf
	$(CROSS)objcopy -O verilog $< $@

./$(OBJECT-U-TYPE)/$(OBJECT-U-TYPE).bin: ./$(OBJECT-U-TYPE)/$(OBJECT-U-TYPE).elf
	$(CROSS)objcopy -O binary $< $@

./$(OBJECT-U-TYPE)/$(OBJECT-U-TYPE).asm: ./$(OBJECT-U-TYPE)/$(OBJECT-U-TYPE).elf
	$(CROSS)objdump -d $< > $@

# S
$(OBJECT-S-TYPE): ./$(OBJECT-S-TYPE)/$(OBJECT-S-TYPE).elf ./$(OBJECT-S-TYPE)/$(OBJECT-S-TYPE).hex ./$(OBJECT-S-TYPE)/$(OBJECT-S-TYPE).bin ./$(OBJECT-S-TYPE)/$(OBJECT-S-TYPE).asm
clean-$(OBJECT-S-TYPE): ./$(OBJECT-S-TYPE)/$(OBJECT-S-TYPE).elf ./$(OBJECT-S-TYPE)/$(OBJECT-S-TYPE).hex ./$(OBJECT-S-TYPE)/$(OBJECT-S-TYPE).bin ./$(OBJECT-S-TYPE)/$(OBJECT-S-TYPE).asm
	rm $^

./$(OBJECT-S-TYPE)/$(OBJECT-S-TYPE).elf: sections.ld ./$(OBJECT-S-TYPE)/start.S
	$(CROSS)gcc $(CFLAGS) -Wl,-Bstatic,-T,sections.ld -o $@ ./$(OBJECT-S-TYPE)/start.S

./$(OBJECT-S-TYPE)/$(OBJECT-S-TYPE).hex: ./$(OBJECT-S-TYPE)/$(OBJECT-S-TYPE).elf
	$(CROSS)objcopy -O verilog $< $@

./$(OBJECT-S-TYPE)/$(OBJECT-S-TYPE).bin: ./$(OBJECT-S-TYPE)/$(OBJECT-S-TYPE).elf
	$(CROSS)objcopy -O binary $< $@

./$(OBJECT-S-TYPE)/$(OBJECT-S-TYPE).asm: ./$(OBJECT-S-TYPE)/$(OBJECT-S-TYPE).elf
	$(CROSS)objdump -d $< > $@

# B
$(OBJECT-B-TYPE): ./$(OBJECT-B-TYPE)/$(OBJECT-B-TYPE).elf ./$(OBJECT-B-TYPE)/$(OBJECT-B-TYPE).hex ./$(OBJECT-B-TYPE)/$(OBJECT-B-TYPE).bin ./$(OBJECT-B-TYPE)/$(OBJECT-B-TYPE).asm
clean-$(OBJECT-B-TYPE): ./$(OBJECT-B-TYPE)/$(OBJECT-B-TYPE).elf ./$(OBJECT-B-TYPE)/$(OBJECT-B-TYPE).hex ./$(OBJECT-B-TYPE)/$(OBJECT-B-TYPE).bin ./$(OBJECT-B-TYPE)/$(OBJECT-B-TYPE).asm
	rm $^

./$(OBJECT-B-TYPE)/$(OBJECT-B-TYPE).elf: sections.ld ./$(OBJECT-B-TYPE)/start.S
	$(CROSS)gcc $(CFLAGS) -Wl,-Bstatic,-T,sections.ld -o $@ ./$(OBJECT-B-TYPE)/start.S

./$(OBJECT-B-TYPE)/$(OBJECT-B-TYPE).hex: ./$(OBJECT-B-TYPE)/$(OBJECT-B-TYPE).elf
	$(CROSS)objcopy -O verilog $< $@

./$(OBJECT-B-TYPE)/$(OBJECT-B-TYPE).bin: ./$(OBJECT-B-TYPE)/$(OBJECT-B-TYPE).elf
	$(CROSS)objcopy -O binary $< $@

./$(OBJECT-B-TYPE)/$(OBJECT-B-TYPE).asm: ./$(OBJECT-B-TYPE)/$(OBJECT-B-TYPE).elf
	$(CROSS)objdump -d $< > $@

# J
$(OBJECT-J-TYPE): ./$(OBJECT-J-TYPE)/$(OBJECT-J-TYPE).elf ./$(OBJECT-J-TYPE)/$(OBJECT-J-TYPE).hex ./$(OBJECT-J-TYPE)/$(OBJECT-J-TYPE).bin ./$(OBJECT-J-TYPE)/$(OBJECT-J-TYPE).asm
clean-$(OBJECT-J-TYPE): ./$(OBJECT-J-TYPE)/$(OBJECT-J-TYPE).elf ./$(OBJECT-J-TYPE)/$(OBJECT-J-TYPE).hex ./$(OBJECT-J-TYPE)/$(OBJECT-J-TYPE).bin ./$(OBJECT-J-TYPE)/$(OBJECT-J-TYPE).asm
	rm $^

./$(OBJECT-J-TYPE)/$(OBJECT-J-TYPE).elf: sections.ld ./$(OBJECT-J-TYPE)/start.S
	$(CROSS)gcc $(CFLAGS) -Wl,-Bstatic,-T,sections.ld -o $@ ./$(OBJECT-J-TYPE)/start.S

./$(OBJECT-J-TYPE)/$(OBJECT-J-TYPE).hex: ./$(OBJECT-J-TYPE)/$(OBJECT-J-TYPE).elf
	$(CROSS)objcopy -O verilog $< $@

./$(OBJECT-J-TYPE)/$(OBJECT-J-TYPE).bin: ./$(OBJECT-J-TYPE)/$(OBJECT-J-TYPE).elf
	$(CROSS)objcopy -O binary $< $@

./$(OBJECT-J-TYPE)/$(OBJECT-J-TYPE).asm: ./$(OBJECT-J-TYPE)/$(OBJECT-J-TYPE).elf
	$(CROSS)objdump -d $< > $@


clean: clean-$(OBJECT-R-TYPE) clean-$(OBJECT-I-TYPE) clean-$(OBJECT-U-TYPE) clean-$(OBJECT-S-TYPE) clean-$(OBJECT-B-TYPE) clean-$(OBJECT-J-TYPE)
	rm -f *.hex *.elf *.bin
.PHONY: clean all $(OBJECT-R-TYPE) clean-$(OBJECT-I-TYPE) clean-$(OBJECT-U-TYPE) clean-$(OBJECT-S-TYPE) clean-$(OBJECT-B-TYPE) clean-$(OBJECT-J-TYPE)
