Function Set-WinAppWindowMaximize {
    [CmdletBinding()]
    Param()

    Invoke-WinAppRestMethod -Method Post -URI "/window/maximize" | Out-Null
}