# Makefile for the Windows installer on cygwin.  Produces a Microsoft .MSI file
# given an executable, and possibly an image file.
#
# How to build:
# On unix edit and run ./links to get .exe, .map and sources, then on cygwin
# run make

SOURCES := yes
DOCUMENTATION_DIR := doc
GUID_UPGRADE_CODE := FB4E770A-413B-4745-913B-D7EE7041AA48

include branding.gmk

# Cab contents:
VM_EXECUTABLE := $(VM_BASE_NAME).exe
VM_EXECUTABLE_MAP := $(VM_BASE_NAME).map
VM_ICON := $(VM_BASE_NAME).ico
SOURCEFILENAME1 := SqueakV41.sources

CC := /usr/bin/gcc
CP := /usr/bin/cp
SED := /usr/bin/sed
WINDRES := /usr/bin/windres

icon.o:	../nsvm.rc
	$(WINDRES) --include-dir=.. --define _WIN32 -l 0 -i $< -o $@

echovars:
	@echo '$$(VERSION)='$(VERSION)
	@echo '$$(VM_ICON)='$(VM_ICON)
	@echo '$$(DOCUMENTATION_DIR)='$(DOCUMENTATION_DIR)
	@echo 'cygpath $$(DOCUMENTATION_DIR)='"$(shell cygpath -wa $(DOCUMENTATION_DIR))\\"

include installer-Windows.gmk
