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
    NB: Any files with the Test-Case filenames will be overwritten.
    
    Optional Arguments:
    -Verbose    Enables extra debugging output   
    -FullReset  This switch simply deletes all contents from the specified folder, and
                recreates as a standardised test layout
#>

