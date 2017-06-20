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

Function Get-RandomChars([Int]$NumChars=0, [Bool]$AllowSpecial=$True) {
    If ($NumChars -lt 1) {
        $NumChars = Get-Random -Minimum 10 -Maximum 2000  # completely arbritrary!
    }

    $ret_val = ""
    Foreach ($i in (1..$NumChars)) {
        $Num = Get-Random -Minimum 65 -Maximum 122
        if ((-Not $AllowSpecial) -And (($Num -gt 90) -And ($Num -lt 97))) {
            $Num = Get-Random -Minimum 65 -Maximum 90
        }
        $ret_val += [Char]$Num
    }
    return $ret_val
}


Function Convert-DateToISOstr ([DateTime]$Date) {
    return "{0,8:yyyyMMdd}" -f $Date
}

Function Set-FakeFileTime ([String]$Path, [DateTime]$DateToSet) {
    If ($DateToSet -eq $Null ) { $DateToSet=(Get-Date) }
    $FileInfo = Get-Item -Path $Path
    $FileInfo
    $FileInfo.creationtime   = $DateToSet
    $FileInfo.lastaccesstime = $DateToSet
    $FileInfo.lastwritetime  = $DateToSet
    $FileInfo
}



Write-Output "Now Resetting Test Directory: ${Path}"
## Reset Base Dir
if (Test-Path $Path) { Remove-Item -Path $Path -Recurse -Force }
New-Item -Path $Path -Type directory -Force


## Now create all test cases

Write-Output "Now Creating Tests to rotate by Number"
## Items By Number
$PathNow = "$Path\Rotate-By-Number"
New-Item -Path $PathNow -Type directory -Force
Get-RandomChars | Out-File -Encoding UTF8 -FilePath "$PathNow\RotateMe"
Get-RandomChars | Out-File -Encoding UTF8 -FilePath "$PathNow\RotateMe.1"
Get-RandomChars | Out-File -Encoding UTF8 -FilePath "$PathNow\RotateMe.2"
Get-RandomChars | Out-File -Encoding UTF8 -FilePath "$PathNow\RotateMe.3"
$PathNow = "$Path\Rotate-By-Number2"
New-Item -Path $PathNow -Type directory -Force
Get-RandomChars | Out-File -Encoding UTF8 -FilePath "$PathNow\RotateMe"
Get-RandomChars | Out-File -Encoding UTF8 -FilePath "$PathNow\RotateMe.1"
Get-RandomChars | Out-File -Encoding UTF8 -FilePath "$PathNow\RotateMe.2"
Get-RandomChars | Out-File -Encoding UTF8 -FilePath "$PathNow\DontRotateMe"
Get-RandomChars | Out-File -Encoding UTF8 -FilePath "$PathNow\DontRotateMe.1"
$PathNow = "$Path\Rotate-By-Number-Lots"
New-Item -Path $PathNow -Type directory -Force
Get-RandomChars | Out-File -Encoding UTF8 -FilePath "$PathNow\RotateMe"
(1..25) | % { Get-RandomChars | Out-File -Encoding UTF8 -FilePath "$PathNow\RotateMe.$_" }


Write-Output "Now Creating Tests to rotate by Day"
## Items By Date
$PathNow = "$Path\Rotate-By-Date-Day"
New-Item -Path $PathNow -Type directory -Force
Get-RandomChars | Out-File -Encoding UTF8 -FilePath "$PathNow\RotateMe"
Get-RandomChars | Out-File -Encoding UTF8 -FilePath "$PathNow\RotateMe.$(Convert-DateToISOstr (Get-Date).AddDays(-1))"
Get-RandomChars | Out-File -Encoding UTF8 -FilePath "$PathNow\RotateMe.$(Convert-DateToISOstr (Get-Date).AddDays(-2))"
Get-RandomChars | Out-File -Encoding UTF8 -FilePath "$PathNow\RotateMe.$(Convert-DateToISOstr (Get-Date).AddDays(-3))"
Write-Output "Now Creating Tests to rotate by Week"
$PathNow = "$Path\Rotate-By-Date-Week"
New-Item -Path $PathNow -Type directory -Force
Get-RandomChars | Out-File -Encoding UTF8 -FilePath "$PathNow\RotateMe"
Get-RandomChars | Out-File -Encoding UTF8 -FilePath "$PathNow\RotateMe.$(Convert-DateToISOstr (Get-Date).AddDays(-7))"
Get-RandomChars | Out-File -Encoding UTF8 -FilePath "$PathNow\RotateMe.$(Convert-DateToISOstr (Get-Date).AddDays(-14))"
Get-RandomChars | Out-File -Encoding UTF8 -FilePath "$PathNow\RotateMe.$(Convert-DateToISOstr (Get-Date).AddDays(-21))"
$PathNow = "$Path\Rotate-By-Date-Week2"
New-Item -Path $PathNow -Type directory -Force
Get-RandomChars | Out-File -Encoding UTF8 -FilePath "$PathNow\RotateMe"
Get-RandomChars | Out-File -Encoding UTF8 -FilePath "$PathNow\RotateMe.$(Convert-DateToISOstr (Get-Date).AddDays(-7))"
Get-RandomChars | Out-File -Encoding UTF8 -FilePath "$PathNow\RotateMe.$(Convert-DateToISOstr (Get-Date).AddDays(-14))"
Get-RandomChars | Out-File -Encoding UTF8 -FilePath "$PathNow\RotateMe.$(Convert-DateToISOstr (Get-Date).AddDays(-21))"
Get-RandomChars | Out-File -Encoding UTF8 -FilePath "$PathNow\DontRotateMe"
Get-RandomChars | Out-File -Encoding UTF8 -FilePath "$PathNow\DontRotateMe.$(Convert-DateToISOstr (Get-Date).AddDays(-7))"


Write-Output "Now Creating Tests to rotate by Size"
## Large Items
$FileSizeKB = 4096
$ContentBase = (Get-RandomChars 1024)   # 1024 bytes of random chars
$FullContents = $ContentBase*$FileSizeKB

$PathNow = "$Path\Rotate-By-Size"
New-Item -Path $PathNow -Type directory -Force
$FullContents | Out-File -Encoding UTF8 -FilePath "$PathNow\RotateMe"
Get-RandomChars | Out-File -Encoding UTF8 -FilePath "$PathNow\RotateMe.1"
Get-RandomChars | Out-File -Encoding UTF8 -FilePath "$PathNow\RotateMe.2"
Get-RandomChars | Out-File -Encoding UTF8 -FilePath "$PathNow\RotateMe.3"

$PathNow = "$Path\Rotate-By-Size2"
New-Item -Path $PathNow -Type directory -Force
$FullContents | Out-File -Encoding UTF8 -FilePath "$PathNow\RotateMe"
Get-RandomChars | Out-File -Encoding UTF8 -FilePath "$PathNow\RotateMe.1"
Get-RandomChars | Out-File -Encoding UTF8 -FilePath "$PathNow\RotateMe.2"
$FullContents | Out-File -Encoding UTF8 -FilePath "$PathNow\DontRotateMe"
Get-RandomChars | Out-File -Encoding UTF8 -FilePath "$PathNow\DontRotateMe.1"


Write-Output "Now Creating Tests to rotate by Date"
## Old Items
$DateVeryOld = (Get-Date "01/01/2017 12:00 am")

$PathNow = "$Path\Rotate-By-Date-Days"
New-Item -Path $PathNow -Type directory -Force
$FilePath = "$PathNow\RotateMe"
Get-RandomChars | Out-File -Encoding UTF8 -FilePath  $FilePath
Set-FakeFileTime -Path $FilePath -DateToSet (Get-Date)
(1..3) | % {
    $FilePath = "$PathNow\RotateMe.$_"
    Get-RandomChars | Out-File -Encoding UTF8 -FilePath $FilePath
    Set-FakeFileTime -Path $FilePath -DateToSet ((Get-Date).AddDays(-1*$_))
}

$PathNow = "$Path\Rotate-By-Date-Weeks"
New-Item -Path $PathNow -Type directory -Force
$FilePath = "$PathNow\RotateMe"
Get-RandomChars | Out-File -Encoding UTF8 -FilePath  $FilePath
Set-FakeFileTime -Path $FilePath -DateToSet (Get-Date)
(1..3) | % {
    $FilePath = "$PathNow\RotateMe.$_"
    Get-RandomChars | Out-File -Encoding UTF8 -FilePath $FilePath
    Set-FakeFileTime -Path $FilePath -DateToSet ((Get-Date).AddDays(-7*$_))
}

Write-Output "Now Completed Test Case Setup"
