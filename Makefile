CC=gcc
VERSION=1.4.1
CFLAGS=-I./include

ifeq ($(DEBUG),1)
	CFLAGS+= -g -Wall -Wextra -Wpedantic -DDEBUG=1
else
	CFLAGS+= -O2
	ifeq ($(ARCH_LINUX),1)
		CFLAGS+= -DARCH_LINUX
		SCRIPTS_FOLDER=/usr/local/bin/texted
	else
		SCRIPTS_FOLDER=/usr/libexec/texted
	endif
endif

ifeq ($(ANDROID), 1)
	CFLAGS+= -DANDROID
endif

CFLAGS += -lncurses -pthread -lreadline -lhistory

TARGET=texted
OBJ=src/edit.o src/insert.o src/print.o src/permissions.o src/texted.o  src/fileio.o src/credits.o src/unirun.o main.o

all: $(TARGET)

%.o: %.c %.h
	$(CC) $(CFLAGS) -c $<

$(TARGET): $(OBJ)
	$(CC) $(CFLAGS) $^ -o $@

clean:
	rm src/*.o
	rm *.o $(TARGET)

install:
	# Install man page
	sudo mkdir /usr/local/man/man1
	sudo cp docs/texted.1 /usr/local/man/man1
	sudo gzip /usr/local/man/man1/texted.1
	sudo mandb

	# Install assets
	sudo mkdir /usr/share/texted
	sudo cp -r assets/ /usr/share/texted

	# Install scripts
	sudo mkdir -p $(SCRIPTS_FOLDER)
	sudo cp -r src/highlighter $(SCRIPTS_FOLDER)

	sudo install $(TARGET) /usr/bin

remove:
	sudo rm -rf /usr/local/man/man1
	sudo rm -rf /usr/share/texted
	sudo rm -rf $(SCRIPTS_FOLDER)
	sudo rm /usr/bin/$(TARGET)