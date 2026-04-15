# Assembler configuration
AS = nasm
ASFLAGS = -f bin

# Directory variables
TIMESTAMP := $(shell date +%Y-%m-%d-%dT%H-%M-%S)
BUILDROOT := builds/$(TIMESTAMP)

SRC = ./src
TARGET_IMG = $(BUILDROOT)/disk.img

SRC_BOOT = $(SRC)/boot.asm
TARGET_BOOT = $(BUILDROOT)/boot.bin

# Binary source files
SRC_BINS := $(shell find $(SRC)/root -name "*.asm")
# Map binary sources to output binary files in the build root
TARGET_BINS := $(SRC_BINS:$(SRC)/root/%.asm=$(BUILDROOT)/root/%.bin)

.PHONY: all clean run

all: $(TARGET_IMG)

# Rules

# Build root directory
$(BUILDROOT):
	mkdir -p $(BUILDROOT)

# Assemble additional assembly binaries
$(BUILDROOT)/root/%.bin: $(SRC)/root/%.asm | $(BUILDROOT)
	mkdir -p $(dir $@)
	$(AS) $(ASFLAGS) $< -o $@

# Assemble system bootsector
$(TARGET_BOOT): $(SRC_BOOT) | $(BUILDROOT)
	$(AS) $(ASFLAGS) $< -o $@

# Create disk image, setup boot data, copy additional binaries to image
$(TARGET_IMG): $(TARGET_BOOT) $(TARGET_BINS)
	dd if=/dev/zero of=$@ bs=512 count=2880
	mkfs.fat -F 12 $@
	dd if=$(TARGET_BOOT) of=$@ bs=1 skip=62 seek=62 count=448 conv=notrunc
	mcopy -i $@ $(TARGET_BINS) ::

clean:
	rm -rf ./builds/**

# Run the latest disk image in qemu
run:
	@LATEST=$$(ls -dt builds/* | head -n 1); \
	echo Running $$LATEST; \
	qemu-system-i386 -drive format=raw,file=$$LATEST/disk.img