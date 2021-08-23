Function Get-WinAppActiveElement {
    [CmdletBinding()]
    Param()
    
    Invoke-WinAppRestMethod -Method Post -URI "/element/active" | ForEach-Object { $_.value.ELEMENT }
}