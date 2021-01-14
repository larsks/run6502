prefix = /usr
bindir = $(prefix)/bin

INSTALL = install

OBJS = \
       main.o \
       fake6502.o

CFLAGS = -g

all: run6502

run6502: $(OBJS)
	$(CC) -o $@ $(OBJS)

clean:
	rm -f $(OBJS)

install: all
	$(INSTALL) -m 755 run6502 $(DESTDIR)$(bindir)/
