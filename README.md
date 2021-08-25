## WinAppDriverPS

### Introduction

This module utilized the WinAppDriver service to run UI automation via Powershell.

Windows Application Driver (WinAppDriver) is a service to support Selenium-like UI Test Automation on Windows Applications. This service supports testing Universal Windows Platform (UWP), Windows Forms (WinForms), Windows Presentation Foundation (WPF), and Classic Windows (Win32) apps on Windows 10 PCs.


### Install & Run WinAppDriver
1. Download Windows Application Driver installer from <https://github.com/Microsoft/WinAppDriver/releases>
2. Run the installer on a Windows 10 machine where your application under test is installed and will be tested
3. Enable [Developer Mode](https://docs.microsoft.com/en-us/windows/uwp/get-started/enable-your-device-for-development) in Windows settings

### Usage Examples

1. Clone the repo and import the module.
2. Start the WinAppDriver using:  
`Start-WinAppDriver`
3. Start a new WinAppDriver session of Notepad using:  
  `New-WinAppSession -App notepad `  
  or  
  `New-WinAppSession -App notepad.exe`  
  or   
  `New-WinAppSession -App 'c:\Windows\System32\notepad.exe'`  

4. To find an element in the application we can use the following
    `Get-WinAppElement -By Name -Value 'File'`
    > **Note**: Elements are case sensitive!
5. Once you find element and you save it to a variable you can invoke a mouse click 
   ```
   $e = Get-WinAppElement -By Name -Value 'File'
   Invoke-WinAppClick -Element $e
   ```
6. We can also send keystrokes to a text element 
   ```
   $e = Get-WinAppElement -By Name -Value 'Text Editor'
   Invoke-WinAppKeys -Element $e -Keys @('Hello World!' ,'{ENTER}','This is Awesome!')
   ```


