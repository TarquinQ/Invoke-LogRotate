<#
.SYNOPSIS
    This script creates test cases for the LogRotate script.
.DESCRIPTION
    This script creates several test cases for the LogRotate script to work on.
    This should give it enough new cases to re-test functionality for 
    each of the types of rotation possible.
.NOTES
    This script is generally used only during development and testing.
.LINK
    https://github.com/TarquinQ/Invoke-LogRotate
.EXAMPLE
    To create all test cases, simply run:
    powershell -ExecutionPolicy Bypass GenerateTestCases.ps1 -Path <OutputPath>
    At this stage, there is no seperated test case generation.

.EXAMPLE
    NB: Any files within the Test-Case diretory will be deleted.
    
    Optional Arguments:
    -Verbose    Enables extra debugging output   
#>
param (
    [String]$Path=($PSScriptRoot + "\Test-Cases")
)

$ErrorActionPreference = "Continue"
$Global:VerbosePreference = 'Continue'
$Script:VerbosePreference = 'Continue'
$VerbosePreference = 'Continue'


Function RecreatePath {
    param (
        [Parameter(Mandatory=$True)][String]$Path,
        [Parameter(Mandatory=$True)][Object[]]$SubDirArray
    )
    $prevErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = Stop
    if (Test-Path $Path) { Remove-Item -Path $Path -Force }
    New-Item -Path $Path -Force
    $SubDirArray | % { New-Item -Path $_ -Force }
    $ErrorActionPreference = $prevErrorActionPreference
}


Function CreateLargeItem {
    param (
        [Parameter(Mandatory=$True)][String]$Path,
        [Parameter(Mandatory=$True)][String[]]$Filenames,
        [Parameter(Mandatory=$True)][Int]$FileSizeKB
    )
    $ContentBase = ( -Join ((65..90) + (97..122) | Get-Random -Count 1024 | % {[char]$_}) )  # 1024 bytes of random chars
    $FullContents = $ContentBase*$FileSizeKB
    ForEach ($filename in $filenames) { New-Item -Path "${Path}\${Filename}" -type file -Force }
}


