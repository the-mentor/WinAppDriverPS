Function Start-WinAppDriver {
    Param (
        $ExePath = "C:\Program Files (x86)\Windows Application Driver\WinAppDriver.exe",
        $ArgumentList = "127.0.0.1 4723/wd/hub"
    )

    Start-Process -WindowStyle Minimized -FilePath $ExePath -ArgumentList $ArgumentList
}