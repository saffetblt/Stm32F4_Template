PROJ_NAME=template
OBJDIR = build

######################################################################
#                         SETUP SOURCES                              #
######################################################################

SRCS = src/main.c
SRCS  += inc/system_stm32f4xx.c
SRCS  += inc/startup_stm32f4xx.s
	   
INC_DIRS  = libraries/CMSIS/Include
INC_DIRS += libraries/CMSIS/ST/STM32F4xx/Include
	
######################################################################
#                         SETUP TOOLS                                #
######################################################################

CC      = arm-none-eabi-gcc
OBJCOPY = arm-none-eabi-objcopy
GDB     = arm-none-eabi-gdb
INCLUDE = $(addprefix -I,$(INC_DIRS))
DEFS    = -DSTM32F40_41xxx

CFLAGS  = -ggdb
CFLAGS += -Os 
CFLAGS += -Wall -Wextra -Warray-bounds
CFLAGS += -mlittle-endian -mthumb -mcpu=cortex-m4 -mthumb-interwork
CFLAGS += -mfloat-abi=hard -mfpu=fpv4-sp-d16

LFLAGS  = -T inc/stm32f4_flash.ld

######################################################################
#                         SETUP TARGETS                              #
######################################################################

.PHONY: $(OBJDIR)/$(PROJ_NAME)
$(OBJDIR)/$(PROJ_NAME): $(OBJDIR)/$(PROJ_NAME).elf

$(OBJDIR)/$(PROJ_NAME).elf: $(SRCS)
	$(CC) $(INCLUDE) $(DEFS) $(CFLAGS) $(LFLAGS) $^ -o $@ 
	$(OBJCOPY) -O ihex $(OBJDIR)/$(PROJ_NAME).elf $(OBJDIR)/$(PROJ_NAME).hex
	$(OBJCOPY) -O binary $(OBJDIR)/$(PROJ_NAME).elf $(OBJDIR)/$(PROJ_NAME).bin

clean:
	rm -f *.o $(OBJDIR)/$(PROJ_NAME).elf $(OBJDIR)/$(PROJ_NAME).hex $(OBJDIR)/$(PROJ_NAME).bin

flash: 
	st-flash write $(OBJDIR)/$(PROJ_NAME).bin 0x8000000