Function Invoke-WinAppClick {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]$Element,
        [switch]$Doubleclick
    )

    Invoke-WinAppRestMethod -Method Post -URI "/element/$($Element.ID)/click" 
}