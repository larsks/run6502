DASM = dasm

SRCS = swapcase.s \
       clioptions.s \
       stringtable.s \
       ls65.s

OBJS = $(SRCS:.s=.o)
LSTS = $(SRCS:.s=.lst)
PRGS = $(SRCS:.s=.r65)
BINS = $(SRCS:.s=.bin)
DEPS = $(SRCS:.s=.d)

%.d: %.s
	python mkdeps.py $< > $@ || rm -f $@

%.bin: %.s header.s
	$(DASM) $< -f3 -o$@ -l$(<:.s=.lst) -DNOHEADER

%.r65: %.s
	$(DASM) $< -f3 -o$@
	chmod 755 $@

all: $(PRGS) $(BINS)

clean:
	rm -f $(PRGS) $(OBJS) $(LSTS) $(BINS)

include $(DEPS)
