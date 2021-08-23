Function Get-WinAppElementAttribute {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)][string[]]$ElementID,
        [string[]]$Attribute = "Name"
        #[switch]$ReturnFirst
    )

    foreach ($Element in $ElementID) {
        $result = @{}
        $result['ID'] = $Element

        foreach ($Attr in $Attribute) {
            $value = Invoke-WinAppRestMethod -Method Get -URI "/element/$Element/attribute/$Attr" | Select-Object -ExpandProperty Value
            $result[$Attr] = $value
        }

        $result
    }
}