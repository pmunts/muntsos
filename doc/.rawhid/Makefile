CC	 	= $(CROSS_COMPILE)gcc
CFLAGS		+= -Wall $(DEBUGFLAGS) $(EXTRAFLAGS)
STRIP		= $(CROSS_COMPILE)strip

# Cygwin

ifeq ($(findstring CYGWIN, $(shell uname)), CYGWIN)
LDFLAGS		+= -lhidapi
endif

# Linux

ifeq ($(shell uname), Linux)
LDFLAGS		+= -lhidapi-hidraw
endif

# MacOS X

ifeq ($(shell uname), Darwin)
CFLAGS		+= -I/usr/local/include
LDFLAGS		+= -lhidapi
endif

# Define a pattern rule to compile a C program

%: %.c
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)
	$(STRIP) $@

# Compile the test program

default: test_version

# Remove working files

clean:
	rm -rf test_version
