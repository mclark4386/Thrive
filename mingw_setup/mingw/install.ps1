param(
    [string]$MINGW_ENV
)

#########
# MinGW #
#########

Write-Output "--- Installing MinGW ---"

$DIR = Split-Path $MyInvocation.MyCommand.Path

#################
# Include utils #
#################

. (Join-Path "$DIR\.." "utils.ps1")


############################
# Create working directory #
############################

$WORKING_DIR = Join-Path $MINGW_ENV temp\mingw

mkdir $WORKING_DIR -force | out-null

###################
# Check for 7-Zip #
###################

$7z = Join-Path $MINGW_ENV "temp\7zip\7za.exe"

if (-Not (Get-Command $7z -errorAction SilentlyContinue))
{
    return $false
}


####################
# Download archive #
####################

$REMOTE_DIR="http://downloads.sourceforge.net/project/mingw-w64/Toolchains%20targetting%20Win32/Personal%20Builds/rubenvb/gcc-4.7-release"
$ARCHIVE="i686-w64-mingw32-gcc-4.7.4-release-win32_rubenvb.7z"

$DESTINATION = Join-Path $WORKING_DIR $ARCHIVE

if (-Not (Test-Path $DESTINATION)) {
    Write-Output "Downloading archive..."
    $CLIENT = New-Object System.Net.WebClient
    $CLIENT.DownloadFile("$REMOTE_DIR/$ARCHIVE", $DESTINATION)
}
else {
    Write-Output "Found archive file, skipping download."
}

##########
# Unpack #
##########

$ARGUMENTS = "x",
             "-y",
             "-o$WORKING_DIR",
             $DESTINATION
             
Write-Output "Unpacking archive..."

& $7z $ARGUMENTS | out-null

Write-Output "Installing..."

Copy-Item (Join-Path $WORKING_DIR "mingw32\*") -destination $MINGW_ENV -Recurse -Force
