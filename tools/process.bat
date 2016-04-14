@echo off

echo [!] --- UNIVERSAL INJECT GENERATOR v0.6 ---
echo.
echo [+] CLEAR WORKING DIRECTORY
rd /s /q work
echo.
echo [+] IDENTIFY FILES TO WORK WITH
md work
copy /y /v %2 work\hs.app
tools\ctrtool -x --contents work\ciacnt %1
ren "work\ciacnt.0000.*" inject.app

echo.
echo [+] EXTRACT HS AND INJECT APP
tools\3dstool -x -f work\hs.app --header work\hs_hdr.bin --exh work\hs_exhdr.bin --plain work\hs_plain.bin --logo work\hs_logo.bin --exefs work\hs_exefs.bin
tools\3dstool -x -f work\inject.app --exh work\inject_exhdr.bin --exefs work\inject_exefs.bin --romfs work\inject_romfs.bin
tools\3dstool -x -f work\hs_exefs.bin --exefs-dir work\hs_exefs
tools\3dstool -x -f work\inject_exefs.bin --exefs-dir work\inject_exefs

echo.
echo [+] GENERATE NO BANNER EXEFS
copy /y /v work\hs_exefs\banner.bnr work\inject_exefs\banner.bnr
tools\3dstool -c -z -t exefs -f work\inject_no_banner_exefs.bin --exefs-dir work\inject_exefs --header work\inject_exefs.bin

echo.
echo [+] GENERATE DUMMY ROMFS
md work\dummy_romfs
copy /y /v tools\dummy.bin work\dummy_romfs\dummy.bin
tools\3dstool -c -t romfs -f work\dummy_romfs.bin --romfs-dir work\dummy_romfs
if not exist work\inject_romfs.bin (ren work\dummy_romfs.bin inject_romfs.bin)

echo.
echo [+] MERGE EXHEADER
tools\MergeExHeader work\inject_exhdr.bin work\hs_exhdr.bin work\merge_exhdr.bin

echo.
echo [+] REBUILD HS INJECT APP
if exist work\hs_logo.bin (tools\3dstool -c -t cxi -f %~n1_inject_no_banner.app --header work\hs_hdr.bin --exh work\merge_exhdr.bin --plain work\hs_plain.bin --logo work\hs_logo.bin --exefs work\inject_no_banner_exefs.bin --romfs work\inject_romfs.bin) else (tools\3dstool -c -t cxi -f %~n1_inject_no_banner.app --header work\hs_hdr.bin --exh work\merge_exhdr.bin --plain work\hs_plain.bin --exefs work\inject_no_banner_exefs.bin --romfs work\inject_romfs.bin)
if exist work\hs_logo.bin (tools\3dstool -c -t cxi -f %~n1_inject_with_banner.app --header work\hs_hdr.bin --exh work\merge_exhdr.bin --plain work\hs_plain.bin --logo work\hs_logo.bin --exefs work\inject_exefs.bin --romfs work\inject_romfs.bin) else (tools\3dstool -c -t cxi -f %~n1_inject_with_banner.app --header work\hs_hdr.bin --exh work\merge_exhdr.bin --plain work\hs_plain.bin --exefs work\inject_exefs.bin --romfs work\inject_romfs.bin)

for %%i in (work\hs.app) do set HS_ORIGINAL_SIZE=%%~zi
for %%i in ("%~n1_inject_no_banner.app") do set HS_INJECT_N_SIZE=%%~zi
for %%i in ("%~n1_inject_with_banner.app") do set HS_INJECT_B_SIZE=%%~zi
echo [+] HS APP ORIGINAL SIZE  : %HS_ORIGINAL_SIZE% byte
echo [+] HS APP INJECT (N) SIZE: %HS_INJECT_N_SIZE% byte
if HS_ORIGINAL_SIZE LSS HS_INJECT_N_SIZE (echo [!] INJECT APP IS BIGGER THAN HS APP)
echo [+] HS APP INJECT (B) SIZE: %HS_INJECT_B_SIZE% byte
if HS_ORIGINAL_SIZE LSS HS_INJECT_B_SIZE (echo [!] INJECT APP IS BIGGER THAN HS APP)
echo.
echo [!] --- OPERATION COMPLETE ---
echo.