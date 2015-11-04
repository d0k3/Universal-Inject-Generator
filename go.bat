@echo off
for %%x in (input\*.cia) do call tools\process.bat %%x input\hs.app
pause
