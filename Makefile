PROG = start-stop-daemon

VERSION = 0.1

LOCALEDIR = $(DATADIR)/locale
CPPFLAGS = \
	-DLIBDPKG_VOLATILE_API=1 \
	-DVERSION=\"$(VERSION)\" \
	-DADMINDIR=\"$(ADMINDIR)\" \
	-DLOCALEDIR=\"$(LOCALEDIR)\" \
	-DLOGDIR=\"$(LOGDIR)\" \
	-DSYSCONFDIR=\"$(SYSCONFDIR)\" \
	-I.

MKC_REQUIRE_HEADERS = stddef.h sys/syscall.h error.h
MKC_CHECK_HEADERS = linux/sched.h kvm.h

MKC_REQUIRE_FUNCLIBS = strnlen strerror strsignal strndup asprintf snprintf scandir alphasort unsetenv setsid
MKC_CHECK_FUNCLIBS = clone

MKC_REQUIRE_DEFINES = offsetof:stddef.h va_copy:stdarg.h
MKC_CHECK_DEFINES = CLONE_NEWPID:linux/sched.h TIOCNOTTY:termios.h

SRC = start-stop-daemon.c

.for d in ${MKC_CHECK_HEADERS} ${MKC_REQUIRE_HEADERS}
CPPFLAGS += ${"${HAVE_HEADER.${d:S/\//_/:S/./_/}}" == "1":?-DHAVE_${d:S/\//_/:S/./_/:tu}=1:}
.endfor

.for d in ${MKC_CHECK_FUNCLIBS} ${MKC_REQUIRE_FUNCLIBS}
CPPFLAGS += ${"${HAVE_FUNCLIB.$d}" == "1":?-DHAVE_${d:tu}=1:}
.endfor

.for d in ${MKC_CHECK_DEFINES} ${MKC_REQUIRE_DEFINES}
.for k v in ${d:S/:/ /:tw}
CPPFLAGS += ${"${HAVE_DEFINE.$k.${v:S/\//_/:S/./_/}}" == "1":?-DHAVE_${k:tu}=1:}
.endfor
.endfor

.include <mkc.mk>
