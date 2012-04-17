PREFIX=/usr
XDG_CONFIG_DIR=/etc/xdg
MANPREFIX=/usr/local/man

CFLAGS+=-I/usr/include/freetype2   -DHAVE_XINERAMA -DHAVE_XRANDR -DHAVE_IMLIB
LDFLAGS+=-lX11 -lXft -lfreetype -lXinerama -lXrandr -lImlib2   -lpthread

PROG=kwm
MAN=kwm.1

# kwm version
VERSION= 0.01

SRCS= \
src/barwin.c \
src/client.c \
src/config.c \
src/draw.c \
src/event.c \
src/ewmh.c \
src/frame.c \
src/getinfo.c \
src/infobar.c \
src/init.c \
src/launcher.c \
src/layout.c \
src/menu.c \
src/mouse.c \
src/parse_api.c \
src/parse.c \
src/screen.c \
src/status.c \
src/systray.c \
src/tag.c \
src/util.c \
src/vikwm.c \
src/color.c \
src/kwm.c

# flags
CFLAGS+= -DXDG_CONFIG_DIR=\"${XDG_CONFIG_DIR}\"
CFLAGS+= -DKWM_VERSION=\"${VERSION}\"
CFLAGS+= -Wall -Wextra

OBJS= ${SRCS:.c=.o}

all: ${PROG} ${MAN}.gz

${PROG}: ${OBJS} src/structs.h src/kwm.h src/parse.h
	${CC} -o $@ ${OBJS} ${LDFLAGS}

${MAN}.gz: ${MAN}
	gzip -cn -9 ${MAN} > $@

.c.o:
	${CC} -c ${CFLAGS} $< -o $@

clean:
	rm -f ${OBJS} kwm ${MAN}.gz

distclean: clean
	rm -f Makefile


install: all
	@echo installing executable file to ${DESTDIR}${PREFIX}/bin
	mkdir -p ${DESTDIR}${PREFIX}/bin
	install ${PROG} ${DESTDIR}${PREFIX}/bin
	@echo installing manual page to ${DESTDIR}${MANPREFIX}/man1
	mkdir -p ${DESTDIR}${MANPREFIX}/man1
	install -m 644 ${MAN}.gz ${DESTDIR}${MANPREFIX}/man1/
	@echo installing xsession file to ${DESTDIR}${PREFIX}/share/xsessions
	mkdir -p ${DESTDIR}${PREFIX}/share/xsessions
	install -m 644 kwm.desktop ${DESTDIR}${PREFIX}/share/xsessions/
	@echo installing default config file to ${DESTDIR}${XDG_CONFIG_DIR}/kwm/
	mkdir -p ${DESTDIR}${XDG_CONFIG_DIR}/kwm/
	install -m 444 kwmrc ${DESTDIR}${XDG_CONFIG_DIR}/kwm/

uninstall:
	@echo removing executable file from ${DESTDIR}${PREFIX}/bin
	rm -f ${DESTDIR}${PREFIX}/bin/kwm
	@echo removing manual page from ${DESTDIR}${MANPREFIX}/man1
	rm -f ${DESTDIR}${MANPREFIX}/man1/kwm.1.gz
	@echo removing xsession file from ${DESTDIR}${PREFIX}/share/xsessions
	rm -f ${DESTDIR}${PREFIX}/share/xsessions/kwm.desktop
	@echo removing config file from ${DESTDIR}${XDG_CONFIG_DIR}/kwm/
	rm -f ${DESTDIR}${XDG_CONFIG_DIR}/kwm/kwmrc
	rmdir ${DESTDIR}${XDG_CONFIG_DIR}/kwm/



.PHONY: all clean distclean install uninstall

