Function Set-WinAppWindowSize {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)][int]$Height,
        [Parameter(Mandatory = $true)][int]$Width
    )

    $json = [PSCustomObject]@{
        height = $height
        width  = $width

    } | ConvertTo-Json -Compress

    Invoke-WinAppRestMethod -Method Post -URI "/window/size" -Body $json | Out-Null
}