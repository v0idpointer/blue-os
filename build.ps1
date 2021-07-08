# Codename: BlueOS Build Script
# Created by: Aleksey A. "v0idpointer"
# July 7th, 2021.

# If blocked because digital signature is missing:
# Set-ExecutionPolicy -Scope Process -ExecutionPolicy ByPass

$__TIME_WAIT__ = 2

function Err {
    param ($Trace, $CommandOutput)
    
    echo "`n> An error has occurred!"
    echo "Origin: $($Trace)"
    echo "Error: "
    echo $CommandOutput
    Exit
}

function AssemblerCompile {
    param($FileName)
    
    echo "Building '$($FileName)'..."
    
    $__src__ = "src\$($FileName)"
    $__extbegin__ = $FileName.LastIndexOf(".")
    $__rawfilename__ = $FileName.SubString(0, $__extbegin__)
    $__out__ = "bin\$($__rawfilename__).bin"
    
    $pinfo = New-Object System.Diagnostics.ProcessStartInfo
    $pinfo.FileName = "nasm" 
    $pinfo.Arguments = "-f bin -o $($__out__) $($__src__)" 
    $pinfo.UseShellExecute = $false 
    $pinfo.CreateNoWindow = $true 
    $pinfo.RedirectStandardOutput = $true 
    $pinfo.RedirectStandardError = $true

    $process= New-Object System.Diagnostics.Process 
    $process.StartInfo = $pinfo

    $process.Start() | Out-Null 
    sleep -Seconds $__TIME_WAIT__ 
    if (!$process.HasExited) { 
	    $process.Kill() 
    }

    $stdout = $process.StandardOutput.ReadToEnd() 
    $stderr = $process.StandardError.ReadToEnd()

    if($stderr.Length -gt 0) { 
        echo "`tFAILED!"
        Err $FileName $stderr 
    }
    else { 
        echo "`tOK!" 
    }

}

$__skip_compile__ = 0
for ($i = 0; $i -lt $Args.Length; $i++) {

    if($Args[$i] -eq "/NoCompile") {
        $__skip_compile__ = 1
    }

}

if($__skip_compile__ -eq 0) {
    echo "> Build started...`n"

    AssemblerCompile "boot.asm"
    AssemblerCompile "kernel.asm"

    echo "`n> Build finished!"
} else {
    echo "`n> Build skipped!"
}

$__skip_disk__ = 0
$__disk_bootsect_only__ = 0
for ($i = 0; $i -lt $Args.Length; $i++) {

    if($Args[$i] -eq "/SkipDisk") {
        $__skip_disk__ = 1
    }

    if($Args[$i] -eq "/BootOnly") {
        $__disk_bootsect_only__ = 1
    }

}

if($__skip_disk__ -eq 0) {
    
    if($__disk_bootsect_only__ -eq 0) {
        $disk_output = (.\buildflp.bat)
        echo "`n> $($disk_output)"
    } else {
        Copy-Item bin\boot.bin out\blue.flp
        "`n> Floppy disk image built with boot sector only (Kernel not included)!"
    }

} else {
    echo "`n> Floppy disk image not built (Skipped)!"
}

for ($i = 0; $i -lt $Args.Length; $i++) {
    if($Args[$i] -eq "/Run") {
        echo "`n> Running in QEMU..."
        $qemu_output = (qemu-system-i386 -fda out\blue.flp)
        echo "`tOK!"
    }
}

Exit