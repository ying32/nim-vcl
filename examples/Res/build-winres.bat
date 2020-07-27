@echo off
rem windres appres.rc appres.o

windres -i appres.rc -o ../appres_386.o -F pe-i386
windres -i appres.rc -o ../appres_amd64.o -F pe-x86-64

pause