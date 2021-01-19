CA65 = ca65
LD65 = ld65

PRGS = swapcase.r65 \
       clioptions.r65 \
       stringtable.r65 \
       ls65.r65

BINS = $(PRGS:.r65=.bin)
OBJS = $(PRGS:.r65=.o)
DEPS = $(PRGS:.r65=.d)

%.d: %.s
	python mkdeps.py $< > $@ || rm -f $@

%.o: %.s
	$(CA65) $(CA65FLAGS) -t none -o $@ -l $(@:.o=.lst) $<

%.bin: %.o
	$(LD65) $(LD65FLAGS) -m $(@:.bin=.map) --start-addr 0x200 -t none -o $@ $^

%.r65: %.o header.o
	$(LD65)  $(LD65FLAGS) -C run6502.cfg -o $@ $^

all: $(PRGS) $(BINS)

swapcase.r65 swapcase.bin: symbols.o
clioptions.r65 clioptions.bin: symbols.o
stringtable.r65 stringtable.bin: strerror.o println.o symbols.o zeropage.o
ls65.r65 ls65.bin: symbols.o println.o listdir.o zeropage.o

clean:
	rm -f *.r65 *.bin *.lst *.o

include $(DEPS)
