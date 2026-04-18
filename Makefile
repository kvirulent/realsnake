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

SRC_MEDIA := $(shell find $(SRC)/root -not -name "*.asm")
TARGET_MEDIA := $(SRC_MEDIA:$(SRC)/root/%=$(BUILDROOT)/root/%)

.PHONY: all clean run debug

all: $(TARGET_IMG)

# Rules

# Create disk root directory
$(BUILDROOT):
	mkdir -p $(BUILDROOT)

# Assemble additional assembly binaries and output to the disk root directory
$(BUILDROOT)/root/%.bin: $(SRC)/root/%.asm | $(BUILDROOT)
	mkdir -p $(dir $@)
	$(AS) $(ASFLAGS) $< -o $@

# Copy additional media files to the disk root directory
$(BUILDROOT)/root/%: $(SRC)/root/% | $(BUILDROOT)
	cp $< $@

# Assemble system bootsector
$(TARGET_BOOT): $(SRC_BOOT) | $(BUILDROOT)
	$(AS) $(ASFLAGS) $< -o $@

# Create disk image, copy bootloader and root directory to disk image
$(TARGET_IMG): $(TARGET_BOOT) $(TARGET_BINS) $(TARGET_MEDIA)
	dd if=/dev/zero of=$@ bs=512 count=2880
	mkfs.fat -F 12 $@
	dd if=$(TARGET_BOOT) of=$@ bs=1 skip=62 seek=62 count=448 conv=notrunc
	mcopy -i $@ -s $(BUILDROOT)/root/* ::

# Clear the builds folder
clean:
	rm -rf ./builds/**

# Run the latest disk image in QEMU
run:
	@LATEST=$$(ls -dt builds/* | head -n 1); \
	echo Running $$LATEST; \
	qemu-system-i386 -drive format=raw,file=$$LATEST/disk.img

# Run the latest disk image in QEMU configured for debugging
debug:
	@LATEST=$$(ls -dt builds/* | head -n 1); \
	echo Running $$LATEST; \
	echo Running in DEBUG MODE! Execution will be STOPPED until a debugger is connected!; \
	echo Debugger port will be openned at :1234; \
	qemu-system-i386 -drive format=raw,file=$$LATEST/disk.img -s -S