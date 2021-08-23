Function Get-WinAppElement {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]$Value,
        [Parameter(Mandatory = $true)][ValidateSet("Name", "ID", "XPath", "Class Name", "Tag Name")]
        $By
    )

    <#
    Strategy	Description
    class name	Returns an element whose class name contains the search value; compound class names are not permitted.
    css selector	Returns an element matching a CSS selector.
    id	Returns an element whose ID attribute matches the search value.
    name	Returns an element whose NAME attribute matches the search value.
    link text	Returns an anchor element whose visible text matches the search value.
    partial link text	Returns an anchor element whose visible text partially matches the search value.
    tag name	Returns an element whose tag name matches the search value.
    xpath	Returns an element matching an XPath expression.

    #>

    $FindElementJson = [PSCustomObject]@{
        value = $Value
        using = $By.ToLower()
    } | ConvertTo-Json


    $ElementIDs = Invoke-WinAppRestMethod -Method Post -URI "/elements" -Body $FindElementJson | ForEach-Object { $_.value.element}

    foreach ($Element in $ElementIDs) {
        $ElementAttr = Get-WinAppElementAttribute -ElementID $Element -Attribute Name, LegacyName, AutomationId, FrameworkId, ClassName, IsEnabled, IsPassword, HasKeyboardFocus, IsKeyboardFocusable, IsControlElement, ClickablePoint, BoundingRectangle, IsSelectionItemPatternAvailable, IsSelectionPatternAvailable, ProcessId, RuntimeId, Value.Value

        $ElementText = Get-WinAppElementText -ElementID $Element

        [PSCustomObject]@{
            ID                              = $Element
            Name                            = $ElementAttr.name
            LegacyName                      = $ElementAttr.LegacyName
            AutomationId                    = $ElementAttr.AutomationId
            FrameworkId                     = $ElementAttr.FrameworkId
            ClassName                       = $ElementAttr.ClassName
            IsEnabled                       = [System.Convert]::ToBoolean($ElementAttr.IsEnabled)
            IsPassword                      = [System.Convert]::ToBoolean($ElementAttr.IsPassword)
            HasKeyboardFocus                = [System.Convert]::ToBoolean($ElementAttr.HasKeyboardFocus)
            IsKeyboardFocusable             = [System.Convert]::ToBoolean($ElementAttr.IsKeyboardFocusable)
            IsControlElement                = [System.Convert]::ToBoolean($ElementAttr.IsControlElement)
            ClickablePoint                  = $ElementAttr.ClickablePoint
            Top                             = (($ElementAttr.BoundingRectangle -split ' ')[1] -split ':')[-1]
            Left                            = (($ElementAttr.BoundingRectangle -split ' ')[0] -split ':')[-1]
            Width                           = (($ElementAttr.BoundingRectangle -split ' ')[2] -split ':')[-1]
            Height                          = (($ElementAttr.BoundingRectangle -split ' ')[3] -split ':')[-1]
            BoundingRectangle               = $ElementAttr.BoundingRectangle
            IsSelectionItemPatternAvailable = [System.Convert]::ToBoolean($ElementAttr.IsSelectionItemPatternAvailable)
            IsSelectionPatternAvailable     = [System.Convert]::ToBoolean($ElementAttr.IsSelectionPatternAvailable)
            ProcessId                       = $ElementAttr.ProcessId
            RuntimeId                       = $ElementAttr.RuntimeId
            ElementText                     = $ElementText
        }
    }
}