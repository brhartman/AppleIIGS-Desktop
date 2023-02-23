# Name for the executable and disk
NAME=DESKTOP
# Name of source file for the program entry point
MAIN=main
# Set to 0 for a ProDOS program (boot directly from the disk and directly into the program)
# Set to 1 for a GS/OS program (boot into GS/OS and run the program from the finder)
ISGSOS=1
# Default speed for KEGS to run at
SPEED=2

########

IIGS=/opt/appleiigs

DISKNAME=$(NAME)
DISKPATH=bin/$(NAME).po
CONFIGPATH=config.kegs

ifeq ($(ISGSOS), 1)
# Run from GS/OS
MAINBIN=obj/$(NAME)\#B30001
S7D1=$(IIGS)/disks/GSOS.2mg
S5D1=$(DISKPATH)
else
# Run from ProDOS
MEMADDR=2000
MAINBIN=obj/$(NAME).SYSTEM\#FF$(MEMADDR)
S7D1=$(DISKPATH)
S5D1=
endif

all: disk

bin: $(MAINBIN)
$(MAINBIN): $(shell find src -type f | grep '\.s$$') Makefile
	make indent
	Merlin32 -V $(IIGS)/dev/macros src/$(MAIN).s
	mkdir -p `dirname $(MAINBIN)`
	mv src/$(MAIN) $(MAINBIN)
	rm src/_FileInformation.txt

disk: $(DISKPATH)
$(DISKPATH): $(MAINBIN)
	mkdir -p `dirname $(DISKPATH)`
	cadius CREATEVOLUME $(DISKPATH) $(DISKNAME) 800KB
	if [ "$(ISGSOS)" -eq 0 ]; then \
		cadius ADDFILE $(DISKPATH) $(DISKNAME) $(IIGS)/dev/lib/PRODOS\#FF0000; \
	fi
	cadius ADDFILE $(DISKPATH) $(DISKNAME) $(MAINBIN)
	cadius CATALOG $(DISKPATH)

config: $(CONFIGPATH)
$(CONFIGPATH): $(DISKPATH)
	cat /dev/null > $(CONFIGPATH)
	echo 's5d1 = $(S5D1)' >> $(CONFIGPATH)
	echo 's6d1 = $(IIGS)/disks/Blank_525_1.po' >> $(CONFIGPATH)
	echo 's6d2 = $(IIGS)/disks/Blank_525_2.po' >> $(CONFIGPATH)
	echo 's7d1 = $(S7D1)' >> $(CONFIGPATH)
	echo 'g_limit_speed = $(SPEED)' >> $(CONFIGPATH)
	echo 'g_cfg_rom_path = $(IIGS)/dev/lib/APPLE2GS.ROM2'  >> $(CONFIGPATH)

run: disk config
	xkegs

indent:
	ls src/*.s | xargs -n 1 cadius INDENTFILE
	ls src/*.s | xargs -n 1 sed --in-place -e :a -e '/^\n*$$/{$$d;N;};/\n$$/ba'

clean:
	rm -f config.kegs
	rm -f src/_FileInformation.txt src/*_Output.txt
	rm -rf bin obj
