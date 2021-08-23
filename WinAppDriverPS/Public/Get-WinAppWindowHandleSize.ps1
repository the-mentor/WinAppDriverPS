Function Get-WinAppWindowHandleSize {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]$WindowHandle
    )
    
    Invoke-WinAppRestMethod -Method Get -URI "/window/$($WindowHandle)/size" | Select-Object -ExpandProperty Value
}