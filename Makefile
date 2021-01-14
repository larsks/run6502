prefix = /usr
bindir = $(prefix)/bin

INSTALL = install

SRCS = \
       main.c \
       fake6502.c

DEPS = $(SRCS:.c=.d)
OBJS = $(SRCS:.c=.o)

CFLAGS = -g

# from https://www.gnu.org/software/make/manual/html_node/Automatic-Prerequisites.html
%.d: %.c
	$(CC) -MM $< | \
		sed 's,\($*\)\.o[ :]*,\1.o $@ : ,g' > $@ || rm -f $@

all: run6502

run6502: $(OBJS)
	$(CC) -o $@ $(OBJS)

clean:
	rm -f $(OBJS) $(DEPS)

install: all
	$(INSTALL) -m 755 run6502 $(DESTDIR)$(bindir)/

include $(DEPS)
