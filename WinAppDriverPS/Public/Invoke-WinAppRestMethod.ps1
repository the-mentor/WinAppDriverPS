Function Invoke-WinAppRestMethod {
    <#
    .SYNOPSIS
    Wrapper for Invoke-RestMethod/Invoke-WebRequest with WinApp specifics
    .DESCRIPTION
    Wrapper for Invoke-RestMethod/Invoke-WebRequest with WinApp specifics
    .PARAMETER Method
    REST Method:
    Supported Methods: GET, PATCH, POST, PUT, DELETE
    .PARAMETER URI
    API URI, e.g. /window/size
    .PARAMETER Headers
    Optionally supply custom headers
    .PARAMETER Body
    REST Body in JSON format
    .PARAMETER OutFile
    Save the results to a file
    .PARAMETER WebRequest
    Use Invoke-WebRequest rather than the default Invoke-RestMethod
    .INPUTS
    System.String
    Switch
    .OUTPUTS
    System.Management.Automation.PSObject
    .EXAMPLE
    Invoke-WinAppRestMethod -Method GET -URI '/window/size'
    .EXAMPLE
    $JSON = @"
        {
            "name": "Stam Class Name to Find",
            "using": "Class Name",
        }
    "@
    Invoke-WinAppRestMethod -Method POST -URI '/elements"' -Body $JSON -WebRequest
    #>

    [CmdletBinding(DefaultParameterSetName = "Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory = $true, ParameterSetName = "Standard")]
        [Parameter(Mandatory = $true, ParameterSetName = "Body")]
        [Parameter(Mandatory = $true, ParameterSetName = "OutFile")]
        [ValidateSet("GET", "PATCH", "POST", "PUT", "DELETE")]
        [String]$Method,

        [Parameter(Mandatory = $true, ParameterSetName = "Standard")]
        [Parameter(Mandatory = $true, ParameterSetName = "Body")]
        [Parameter(Mandatory = $true, ParameterSetName = "OutFile")]
        [ValidateNotNullOrEmpty()]
        [String]$URI,

        [Parameter(Mandatory = $false, ParameterSetName = "Standard")]
        [Parameter(Mandatory = $false, ParameterSetName = "Body")]
        [Parameter(Mandatory = $false, ParameterSetName = "OutFile")]
        [ValidateNotNullOrEmpty()]
        [System.Collections.IDictionary]$Headers,

        [Parameter(Mandatory = $false, ParameterSetName = "Body")]
        [ValidateNotNullOrEmpty()]
        [String]$Body,

        [Parameter(Mandatory = $false, ParameterSetName = "OutFile")]
        [ValidateNotNullOrEmpty()]
        [String]$OutFile,

        [Parameter(Mandatory = $false, ParameterSetName = "Standard")]
        [Parameter(Mandatory = $false, ParameterSetName = "Body")]
        [Parameter(Mandatory = $false, ParameterSetName = "OutFile")]
        [Switch]$WebRequest
    )


    # --- Test for existing WinApp Session
    if (-not $Script:WinAppSession) {

        throw "WinAppSession variable does not exist. Please run New-WinAppSession first to create it"
    }

    # --- Create Invoke-RestMethod Parameters
    $FullURI = "$($Script:WinAppSession.SessionURL)$($URI)"
    
    # --- Set up default parmaeters
    $Params = @{
        Method      = $Method
        Headers     = $Headers
        Uri         = $FullURI
        ContentType = 'application/json;charset=utf-8'
    }

    if ($PSBoundParameters.ContainsKey("Body")) {
        $Params.Add("Body", $Body)

        # --- Log the payload being sent to the server
        Write-Debug -Message $Body

    }
    elseif ($PSBoundParameters.ContainsKey("OutFile")) {
        $Params.Add("OutFile", $OutFile)
    }

    # --- Support for PowerShell Core certificate checking
    if (!($Script:WinAppSession.SignedCertificates) -and ($IsCoreCLR)) {
        $Params.Add("SkipCertificateCheck", $true);
    }

    # --- Support for PowerShell Core SSL protocol checking
    if (($Script:WinAppSession.SslProtocol -ne 'Default') -and ($IsCoreCLR)) {
        $Params.Add("SslProtocol", $Script:WinAppSession.SslProtocol);
    }

    try {

        # --- Use either Invoke-WebRequest or Invoke-RestMethod
        if ($WebRequest.IsPresent) {
            Invoke-WebRequest @Params
        }
        else {
            $Page = 0
            Do {
                $Result = Invoke-RestMethod @Params
                Write-Output $Result

                # Check if endpoint supports pagination
                $Properties = $Result | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name
                If ($Properties -contains "last") {
                    If (-not $Result.last) {
                        $Page ++
                        # Check if parameter is already specified in Uri
                        $AddParam = "?"
                        If ($FullURI -match "\?") {
                            $AddParam = "&"
                        }
                        $Params.Uri = "$($FullURI)$($AddParam)page=$Page"
                    }
                    Else {
                        $Escape = $true
                    }
                }
                Else {
                    $Escape = $true
                }
            } Until ($Escape)
        }
    }
    catch {

        throw $_
    }
    finally {

        if (!$IsCoreCLR) {

            <#
                Workaround for bug in Invoke-RestMethod. Thanks to the PowerNSX guys for pointing this one out
                https://bitbucket.org/nbradford/powernsx/src
            #>
            $ServicePoint = [System.Net.ServicePointManager]::FindServicePoint($FullURI)
            $ServicePoint.CloseConnectionGroup("") | Out-Null
        }
    }
}