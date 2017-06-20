<#
.SYNOPSIS
    This script creates parses configs for LogRotate script.
.DESCRIPTION
    This script opens and parses the XML configs for Invoke-LogRotate
.NOTES
    This script is used by both the main script and the config valiation script.
    This script is not meant to be called directly.
.LINK
    https://github.com/TarquinQ/Invoke-LogRotate
.EXAMPLE
    To parse a config, simply call:
    Parse-LogRotateConfig -Path <OutputPath>
    This will return parsed configs.
#>

$ErrorActionPreference = 'Stop'
$Global:VerbosePreference = 'Stop'
$Script:VerbosePreference = 'Stop'
$VerbosePreference = 'Stop'

Function Get-XMLContents ([String]$Path) {
    if (-Not (Test-Path $Path)) { Throw [System.IO.FileNotFoundException] "Config file not found: $Path" }
    $FileContents = Get-Content $Path
    $ParsedXML = [xml]$FileContents
    return $ParsedXML
}


# To be moved to Test Suite...
try {
    $fail_NonExistent = Get-XMLContents "/nonexistent"
} catch [System.IO.FileNotFoundException] {
    Write-Host "Ah ha - file not found!!!"
}
    
try {
    $fail_NotReadble = Get-XMLContents "/etc/shadow"
} catch [UnauthorizedAccessException] {
    Write-Host "Ah ha - permission denied!!!"
}

try {
    $fail_NotXML = Get-XMLContents "~/.bash_history"
} catch  {
    Write-Host "Ah ha - XML Parse Error!!!"
}

$SucceedXML = Get-XMLContents "$PSScriptRoot/../SampleConfigs/sample.config.xml"

