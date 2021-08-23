Function Get-WinAppElementText {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]$ElementID
    )

    Invoke-WinAppRestMethod -Method Get -URI "/element/$ElementID/text" | Select-Object -ExpandProperty Value
}