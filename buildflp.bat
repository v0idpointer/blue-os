@echo off
echo Building a disk image...

copy /b bin\boot.bin + bin\kernel.bin out\blue.flp > NUL

echo OK!