Function Set-WinAppWindowHandlePosition {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]$WindowHandle,
        [Parameter(Mandatory = $true)][int]$X,
        [Parameter(Mandatory = $true)][int]$Y
    )

    $json = [PSCustomObject]@{
        x = $X
        y = $Y

    } | ConvertTo-Json -Compress

    Invoke-WinAppRestMethod -Method Post -URI "/window/$($WindowHandle)/position" -Body $json | Out-Null
}