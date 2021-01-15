LD65 = ld65
CA65 = ca65

PRGS = \
       swapcase.r65 \
       clioptions.r65 \
       ls65.r65 \
       stringtable.r65

BINS = $(PRGS:.r65=.bin)

SRCS = $(wildcard *.s)
OBJS = $(SRCS:.s=.o)
LSTS = $(SRCS:.s=.lst)

%.bin: %.o
	$(LD65) $(LD65FLAGS) -t none -o $@ $<

%.r65: %.o header.o
	$(LD65)  $(LD65FLAGS) -C run6502.cfg -o $@ header.o $<
	chmod 755 $@

 %.o: %.s
	$(CA65) $(CA65FLAGS) -t none -o $@ -l $(@:.o=.lst) $<

all: $(PRGS)

clean:
	rm -f $(PRGS) $(OBJS) $(LSTS) $(BINS)
