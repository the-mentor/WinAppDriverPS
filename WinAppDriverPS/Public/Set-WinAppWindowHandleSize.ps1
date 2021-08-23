Function Set-WinAppWindowHandleSize {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]$WindowHandle,
        [Parameter(Mandatory = $true)][int]$Height,
        [Parameter(Mandatory = $true)][int]$Width
    )

    $json = [PSCustomObject]@{
        height = $height
        width  = $width

    } | ConvertTo-Json -Compress

    Invoke-WinAppRestMethod -Method Post -URI "/window/$($WindowHandle)/size" -Body $json | Out-Null
}