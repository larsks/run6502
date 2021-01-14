LD65 = ld65
CA65 = ca65

PRGS = swapcase clioptions

%.bin %.lst: %.o
	$(LD65)  -C run6502.cfg -o $@ $<

 %.o: %.s
	$(CA65) -t none -o $@ -l $(@:.o=.lst) $<

all: $(PRGS)

swapcase: header.o swapcase.o
	$(LD65)  $(LD65FLAGS) -C run6502.cfg -o $@ header.o swapcase.o
	chmod 755 $@

clioptions: header.o clioptions.o
	$(LD65)  $(LD65FLAGS) -C run6502.cfg -o $@ header.o clioptions.o
	chmod 755 $@

clean:
	rm -f $(PRGS) $(OBJS) $(LSTS)
