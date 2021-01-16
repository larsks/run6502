DASM = dasm

PRGS = \
       swapcase.r65 \
       clioptions.r65 \
       ls65.r65 \
       stringtable.r65

BINS = $(PRGS:.r65=.bin)

SRCS = $(wildcard *.s)
OBJS = $(SRCS:.s=.o)
LSTS = $(SRCS:.s=.lst)

%.bin: %.s
	$(DASM) $< -f3 -o$@ -l$(<:.s=.lst) -DNOHEADER

%.r65: %.s header.s
	$(DASM) $< -f3 -o$@ -l$(<:.s=.lst)
	chmod 755 $@

all: $(PRGS)

clean:
	rm -f $(PRGS) $(OBJS) $(LSTS) $(BINS)
