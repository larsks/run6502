LD65 = ld65
CA65 = ca65

PRGS = \
       swapcase.r65 \
       clioptions.r65 \
       ls65.r65 \
       stringtable.r65

BINS = $(PRGS:.r65=.bin)

%.bin: %.o
	$(LD65) -t none -o $@ $<

%.r65: %.o
	$(LD65)  $(LD65FLAGS) -C run6502.cfg -o $@ header.o $<
	chmod 755 $@

 %.o: %.s
	$(CA65) -t none -o $@ -l $(@:.o=.lst) $<

all: $(PRGS)

clean:
	rm -f $(PRGS) $(OBJS) $(LSTS) $(BINS)
