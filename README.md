# the worst operating system in the history of bad operating systems maybe ever

A simple "operating system" that displays a Windows 95 Blue Screen of Death when booted. What is the point of this? Well, this is just a result of being bored and wanting to make a system that crashes everytime it boots.

## Usage

The OS is designed to be booted of a floppy disk on a x86 computer. When building the system, a FLP file is exported, and can be used as a virtual floppy disk image.

The OS has been tested to work on QEMU and VMware. Running in a virtual machine is recommended. Run on real hardware at your own risk.

## Building

Before building, make sure that NASM (Netwide Assembler) is installed, and the environment variable "PATH" points to the location where nasm.exe is installed (usually: C:\Program Files\NASM).

To build the OS, simply run the build.ps1 script in PowerShell.

```batch
.\build.ps1
```

Note: since the script is not signed, PowerShell might refuse to execute the script. This can be bypassed with:
```batch
Set-ExecutionPolicy -Scope Process -ExecutionPolicy ByPass
```

The script will compile both the bootloader and the kernel and create a bootable floppy disk image. If QEMU is installed, and the environment variable "PATH" points to the installation directory, adding a "/Run" argument will boot the OS in QEMU.
```batch
.\build.ps1 /Run
```

The following arguments can be applied:
```
/Run -> Runs the OS in QEMU after the compilation.
/NoCompile -> Skips the compilation.
/BootOnly -> Creates a bootable floppy disk without a kernel present.
/SkipDisk -> Skips the creating of a bootable floppy disk.
```

## License
[MIT](https://choosealicense.com/licenses/mit/)