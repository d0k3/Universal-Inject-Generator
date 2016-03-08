@echo off
if exist input\hs.app (for %%x in (input\*.cia) do call tools\process.bat "%%x" input\hs.app) else (echo [!] hs.app not found, use Decrypt9 to dump it on your 3DS)
pause
