Function Invoke-WinAppKeys {
    [CmdletBinding()]
    Param(
        $Element,
        $Keys,
        [switch]$ClearTextBeforeTyping
    )

    if ($Keys.count -eq 1) {
        $Keys = , $Keys
    }

    $SpecialKeysLookupTable = @{
        '{ENTER}'       = [char]0xE007
        '{Tab}'         = [char]0xE004
        '{Space}'       = [char]0xE00D
        '{BACKSPACE}'   = [char]0xE003
        '{DELETE}'      = [char]0xE017
        '{CANCEL}'      = [char]0xE001
        '{LEFT-ARROW}'  = [char]0xE012
        '{RIGHT-ARROW}' = [char]0xE014
        '{UP-ARROW}'    = [char]0xE013
        '{DOWN-ARROW}'  = [char]0xE015
        '{WINKEY}'      = [char]0xE03D
        '{ALT}'         = [char]0xE00A
        '{CTRL}'        = [char]0xE009
        '{SHIFT}'       = [char]0xE008
        '{F4}'          = [char]0xE034
        '{NULL}'        = [char]0xE000
    }

    $SpecialKeysLookupTable.GetEnumerator() | ForEach-Object {
        if ($Keys -match $_.Key) {
            $Keys = $Keys -replace $_.Key, $_.Value
        }
    }

    #Clears text before sending keys
    if ($ClearTextBeforeTyping) {
        Invoke-WinAppRestMethod -Method Post -URI "/element/$($Element.ID)/clear"  | Out-Null
        #Invoke-RestMethod -Method Post -ContentType 'application/json' -Uri "$SessionURI/element/$($Element.ID)/clear" | Out-Null
    }

    $KeysJson = [PSCustomObject]@{
        value = $Keys
    } | ConvertTo-Json -Compress
    Write-Verbose $KeysJson
    if ($Element) {
        $URI = "/element/$($Element.ID)/value"
    }
    else {
        $URI = "/keys"
    }

    Invoke-WinAppRestMethod -Method Post -URI "$URI" -Body $KeysJson | Out-Null
}