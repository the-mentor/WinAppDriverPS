Function Get-WinAppWindowHandlePosition {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]$WindowHandle
    )

    Invoke-WinAppRestMethod -Method Get -URI "/window/$($WindowHandle)/position" | Select-Object -ExpandProperty Value
}