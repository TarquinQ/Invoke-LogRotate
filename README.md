# Invoke-LogRotate

An implmentation of Linux's logrotate, done in PowerShell (for Windows).  
  
## Usage:
Supply an XML config to the powershell script, eg:  
```bash
powershell -ExecutionPolicy Bypass logrotate.ps1 -Config %Temp%\rotateme.xml -Verbose
```
A configuration-file validator will also be supplied, which can pre-validate 
config files prior to a live-run.  
  
## Aims:
Become a generic log rotation implementation, taking inpiration from the Linux logrotate.  
At this planning stage, I won't get quite as complicated as logrotate, but will do what
we mostly would want to do to rotate logs on a weekly/nightly basis.  
  
Also, at this stage, the script will be stateless, so we won't be able to track
multiple same-day executions like logrotate currently does.  
  
