Function Get-WinAppWindowHandles {
    [CmdletBinding()]
    Param(
        [switch]$Single
    )

    if ($Single) {
        Invoke-WinAppRestMethod -Method Get -URI "/window_handle" | Select-Object -ExpandProperty Value
    }
    else {
        Invoke-WinAppRestMethod -Method Get -URI "/window_handles" | Select-Object -ExpandProperty Value
    }
}