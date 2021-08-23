Function Get-WinAppWindowSize {
    [CmdletBinding()]
    Param()

    Invoke-WinAppRestMethod -Method Get -URI "/window/size" | Select-Object -ExpandProperty Value
}