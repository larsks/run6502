LD65 = ld65
CA65 = ca65

SRCS = $(wildcard *.s)
OBJS = $(SRCS:.s=.o)
PRGS = $(SRCS:.s=.bin)
LSTS = $(SRCS:.s=.lst)

%.bin %.lst: %.o
	$(LD65)  -C run6502.cfg -o $@ $<

 %.o: %.s
	$(CA65) -t none -o $@ -l $(@:.o=.lst) $<

all: $(PRGS)

clean:
	rm -f $(PRGS) $(OBJS) $(LSTS)
