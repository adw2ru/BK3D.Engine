set CA_DIR=%~dp0..\
set CA_COM="BKTurbo8.exe"
set CA_B2O="BKbin2obj.exe"

set ASSEMBLER=%CA_DIR%%CA_COM%
set BIN2OBJ=%CA_DIR%%CA_B2O%

%ASSEMBLER% -l -o cl AR5.ASM
%ASSEMBLER% -l -o cl S5.ASM
%ASSEMBLER% -l -o cl TABS5.ASM
%ASSEMBLER% -l -o cl UTIL5.ASM
%ASSEMBLER% -l -o cl WL5.ASM
%ASSEMBLER% -l -o cl MN5.ASM
%ASSEMBLER% -l -o cl LG5.ASM
%ASSEMBLER% -l -o cl MENU5.ASM
%ASSEMBLER% -l -o cl LDR5.ASM

%ASSEMBLER% -l -r li GAME AR5.obj S5.obj TABS5.obj UTIL5.obj WL5.obj MN5.obj LG5.obj MENU5.obj

%BIN2OBJ% -sbin -lDATA GAME.raw GAME

%ASSEMBLER% -l li BK3DAZ LDR5.obj GAME.obj

md out
md lst
copy *.bin out\*
copy *.lst lst\*

del *.bin
del *.obj
del *.lst
del *.raw

