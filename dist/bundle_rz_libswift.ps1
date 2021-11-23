$dist = $args[0]
$python = Split-Path((Get-Command python.exe).Path)

if (-not (Test-Path -Path 'libswift' -PathType Container)) {
    git clone https://github.com/rizinorg/rz-libswift.git --depth 1 libswift
}
cd libswift
& meson.exe --buildtype=release -Drizin_plugdir=lib\plugins --prefix=$dist --libdir=lib\plugins --datadir=lib\plugins build
ninja -C build install
$pathdll = "$dist\lib\plugins\libswift.dll"
if(![System.IO.File]::Exists($pathdll)) {
    type build\meson-logs\meson-log.txt
    throw (New-Object System.IO.FileNotFoundException("File not found: $pathdll", $pathdll))
}
Remove-Item -Recurse -Force $dist\lib\plugins\libswift.lib
