Function New-WinAppSession {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]$App,
        [string]$BaseURI = "http://127.0.0.1:4723",
        [int]$AppLaunchTimeout = 0,
        [switch]$StartWinAppDriver
    )

    $json = [PSCustomObject]@{
        desiredCapabilities = [PSCustomObject]@{
            platformName          = 'WINDOWS'
            app                   = $App
            "ms:waitForAppLaunch" = $AppLaunchTimeout
        }
    } | ConvertTo-Json -Depth 99 -Compress

    $HubURI = "$BaseURI/wd/hub"

    if ($StartWinAppDriver) {
        Start-WinAppDriver
    }

    $Session = Invoke-RestMethod -Method Post -Uri "$HubURI/session" -ContentType 'application/json' -Body $json -TimeoutSec $($AppLaunchTimeout + 10)

    $Script:WinAppSession = [PSCustomObject]@{
        SessionID             = $Session.sessionId
        SessionURL            = "$($HubURI)/session/$($Session.sessionId)"
        App                   = $Session.value.app
        PlatformName          = $Session.value.platformName
        'ms:waitForAppLaunch' = $Session.value.'ms:waitForAppLaunch'
    }
    
    return $Script:WinAppSession
}