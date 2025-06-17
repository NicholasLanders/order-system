BIN_LIB=CMPSYS
LIBLIST=$(BIN_LIB)
SHELL=/QOpenSys/usr/bin/qsh

all: customers.sql orders.sql orderdisp.dspf orderdisp.pgm.rpgle

## Rules
%.pgm.rpgle:
	system -s "CHGATR OBJ('./QRPGLESRC/$*.rpgle') ATR(*CCSID) VALUE(1252)"
	liblist -a $(LIBLIST);\
	system "CPYFRMSTMF FROMSTMF('./QRPGLESRC/$*.rpgle') TOMBR('/QSYS.LIB/$(BIN_LIB).LIB/QRPGLESRC.FILE/$*.mbr') MBROPT(*REPLACE)"
	liblist -a $(LIBLIST);\
	system "CRTBNDRPG PGM($(BIN_LIB)/$*) SRCSTMF('./QRPGLESRC/$*.rpgle') OPTION(*EVENTF) DBGVIEW(*SOURCE) TGTRLS(*CURRENT)"

%.sql:
	liblist -a $(LIBLIST);\
	system "CPYFRMSTMF FROMSTMF('./QSQLSRC/$*.sql') TOMBR('/QSYS.LIB/$(BIN_LIB).LIB/QSQLSRC.FILE/$*.mbr') MBROPT(*REPLACE)"
	system "CHGPFM FILE($(BIN_LIB)/QSQLSRC) MBR($*) SRCTYPE(SQL)"

%.dspf:
	liblist -a $(LIBLIST); \
	system "CPYFRMSTMF FROMSTMF('./QDDSSRC/$*.dspf') TOMBR('/QSYS.LIB/$(BIN_LIB).LIB/QDDSSRC.FILE/$*.MBR') MBROPT(*REPLACE)"
	liblist -a $(LIBLIST); \
	system "CRTDSPF FILE($(BIN_LIB)/$*) SRCFILE($(BIN_LIB)/QDDSSRC) SRCMBR($*)"
