include make/configs/CONFIGS.mk
include make/Flags.mk
include make/Compiler.mk
include make/Folders.mk
include make/Files.mk

all: $(BIN)

# Assembly files
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.S
	mkdir -p $(dir $@)
	$(ASM) $(ASM_FLAGS) -c $< -o $@


# C files
$(OBJ_DIR)/drivers/%.o: C_FLAGS += -DDRIVERS

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	mkdir -p $(dir $@)
	$(CC) $(C_FLAGS) -c $< -o $@


# CPP files
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp
	mkdir -p $(dir $@)
	$(CPP) $(CPP_FLAGS) -c $< -o $@


# Link
$(TARGET): $(OBJ)
	mkdir -p $(dir $@)
	$(LD) $(LD_FLAGS) -o $@ $(OBJ)
	make disasm
	make full-disasm


# BIN
$(BIN): $(TARGET)
	mkdir -p $(dir $@)
	$(OBJCOPY) -O binary $(TARGET) $(BIN)

# Uimage
UIMAGE = $(BIN_DIR)/$(KERNEL_FILE).uImage
LOAD_ADDR = 0x80000000
ENTRY_ADDR = 0x80000000

uimage: $(BIN)
	mkdir -p $(dir $@)
	mkimage -A arm64 -O linux -T kernel -C none \
	        -a $(LOAD_ADDR) -e $(ENTRY_ADDR) \
	        -d $(BIN) $(UIMAGE)

clean:
	rm -f $(OBJ) $(DISASM) $(TARGET) $(BIN) $(MAP)


disasm: $(OBJ)
	@for o in $(OBJ); do \
	    $(OBJDUMP) -D $$o > $$o.S; \
	done

full-disasm: $(TARGET)
	$(OBJDUMP) -D -S $(TARGET) > $(TARGET).dump.S