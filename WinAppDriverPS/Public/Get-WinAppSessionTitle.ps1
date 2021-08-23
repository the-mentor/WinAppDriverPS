Function Get-WinAppSessionTitle {
    [CmdletBinding()]
    Param()
    
    Invoke-WinAppRestMethod -Method Get -URI "/title" | Select-Object -ExpandProperty Value
}