@echo off

..\php\php -f ../scripts/preprocess.php acpu.mac
if %ERRORLEVEL% NEQ 0 ( exit /b )
..\scripts\macro11.exe -ysl 32 -yus -m ..\scripts\sysmac.sml -l _acpu.lst _acpu.mac
if %ERRORLEVEL% NEQ 0 ( exit /b )
..\php\php -f ../scripts/lst2bin.php _acpu.lst ./release/bk3da.sav sav
if %ERRORLEVEL% NEQ 0 ( exit /b )

..\scripts\rt11dsk d .\release\bk3da.dsk bk3da.sav >NUL
..\scripts\rt11dsk a .\release\bk3da.dsk .\release\bk3da.sav >NUL

..\scripts\rt11dsk d .\release\bk3da.dsk bk3dt1.raw >NUL
..\scripts\rt11dsk d .\release\bk3da.dsk bk3dt2.raw >NUL
..\scripts\rt11dsk d .\release\bk3da.dsk bk3dt3.raw >NUL
..\scripts\rt11dsk d .\release\bk3da.dsk bk3dt4.raw >NUL
..\scripts\rt11dsk d .\release\bk3da.dsk bk3dt5.raw >NUL
..\scripts\rt11dsk d .\release\bk3da.dsk bk3dt6.raw >NUL
..\scripts\rt11dsk d .\release\bk3da.dsk bk3dt7.raw >NUL
..\scripts\rt11dsk d .\release\bk3da.dsk bk3dt8.raw >NUL

..\scripts\rt11dsk a .\release\bk3da.dsk .\release\bk3dt1.raw >NUL
..\scripts\rt11dsk a .\release\bk3da.dsk .\release\bk3dt2.raw >NUL
..\scripts\rt11dsk a .\release\bk3da.dsk .\release\bk3dt3.raw >NUL
..\scripts\rt11dsk a .\release\bk3da.dsk .\release\bk3dt4.raw >NUL
..\scripts\rt11dsk a .\release\bk3da.dsk .\release\bk3dt5.raw >NUL
..\scripts\rt11dsk a .\release\bk3da.dsk .\release\bk3dt6.raw >NUL
..\scripts\rt11dsk a .\release\bk3da.dsk .\release\bk3dt7.raw >NUL
..\scripts\rt11dsk a .\release\bk3da.dsk .\release\bk3dt8.raw >NUL

del _acpu.mac
rem del serial.log
rem del _acpu.lst

echo.
