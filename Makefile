CFLAGS = -g -O2 -Wall -Wextra
LDFLAGS =
LDLIBS = -lX11 -lXext -lXrender

prefix = /usr/local
bindir = $(prefix)/bin

CC = cc
RM = rm -f
INSTALL = install

all: windesktop

install: windesktop
	$(INSTALL) -d -m 755 '$(DESTDIR)$(bindir)'
	$(INSTALL) windesktop '$(DESTDIR)$(bindir)'

clean:
	$(RM) windesktop

.PHONY: all install clean
