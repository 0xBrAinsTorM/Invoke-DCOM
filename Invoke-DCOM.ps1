<#

    License: BSD 3-Clause
    Required Dependencies: None
    Optional Dependencies: None

#>

function Invoke-Travel {
<#
    .SYNOPSIS

        None

    .DESCRIPTION

        Test Script

    .PARAMETER ComputerName

        IP Address or Hostname

    .PARAMETER Method

        Method

    .PARAMETER Command

        Specifies the desired command to be executed

    .EXAMPLE

#>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeLine = $true, ValueFromPipelineByPropertyName = $true)]
        [String]
        $ComputerName,

        [Parameter(Mandatory = $true, Position = 1)]
        [ValidateSet("MMC20.Application", "ShellWindows","ShellBrowserWindow","CheckDomain","ServiceCheck","MinimizeAll","ServiceStop","ServiceStart",
        "DetectOffice","RegisterXLL","ExcelDDE")]
        [String]
        $Method = "MMC20.Application",

        [Parameter(Mandatory = $false, Position = 2)]
        [string]
        $ServiceName,

        [Parameter(Mandatory = $false, Position = 3)]
        [string]
        $Command= "notepad.exe",

        [Parameter(Mandatory = $false, Position = 4)]
        [string]
        $DllPath

    )

    Begin {

    #Declaration
       if ($Method -Match "ShellWindows") {

            [String]$DCOM = '9BA05972-F6A8-11CF-A442-00A0C90A8F39'
        }
        
        elseif ($Method -Match "ShellBrowserWindow") {

            [String]$DCOM = 'C08AFD90-F2A1-11D1-8455-00A0C91F3880'
        }

        elseif ($Method -Match "CheckDomain") {

            [String]$DCOM = 'C08AFD90-F2A1-11D1-8455-00A0C91F3880'
        }

        elseif ($Method -Match "ServiceCheck") {

            [String]$DCOM = 'C08AFD90-F2A1-11D1-8455-00A0C91F3880'
        }

        elseif ($Method -Match "MinimizeAll") {

            [String]$DCOM = 'C08AFD90-F2A1-11D1-8455-00A0C91F3880'
        }

        elseif ($Method -Match "ServiceStop") {

            [String]$DCOM = 'C08AFD90-F2A1-11D1-8455-00A0C91F3880'
        }

        elseif ($Method -Match "ServiceStart") {

            [String]$DCOM = 'C08AFD90-F2A1-11D1-8455-00A0C91F3880'
        }
    }
    
    
    Process {

        if ($Method -Match "MMC20.Application") {

            $Com = [Type]::GetTypeFromProgID("MMC20.Application","$ComputerName")
            $Obj = [System.Activator]::CreateInstance($Com)
            $Obj.Document.ActiveView.ExecuteShellCommand($Command,$null,$null,"7")
        }
        elseif ($Method -Match "ShellWindows") {

            $Com = [Type]::GetTypeFromCLSID("$DCOM","$ComputerName")
            $Obj = [System.Activator]::CreateInstance($Com)
            $Item = $Obj.Item()
            $Item.Document.Application.ShellExecute("cmd.exe","/c $Command","c:\windows\system32",$null,0)
        }

        elseif ($Method -Match "ShellBrowserWindow") {

            $Com = [Type]::GetTypeFromCLSID("$DCOM","$ComputerName")
            $Obj = [System.Activator]::CreateInstance($Com)
            $Obj.Document.Application.ShellExecute("cmd.exe","/c $Command","c:\windows\system32",$null,0)
        }

        elseif ($Method -Match "CheckDomain") {

            $Com = [Type]::GetTypeFromCLSID("$DCOM","$ComputerName")
            $Obj = [System.Activator]::CreateInstance($Com)
            $Obj.Document.Application.GetSystemInformation("IsOS_DomainMember")
        }

        elseif ($Method -Match "ServiceCheck") {

            $Com = [Type]::GetTypeFromCLSID("C08AFD90-F2A1-11D1-8455-00A0C91F3880","$ComputerName")
            $Obj = [System.Activator]::CreateInstance($Com)
            $obj.Document.Application.IsServiceRunning("$ServiceName")
        }

        elseif ($Method -Match "MinimizeAll") {

            $Com = [Type]::GetTypeFromCLSID("C08AFD90-F2A1-11D1-8455-00A0C91F3880","$ComputerName")
            $Obj = [System.Activator]::CreateInstance($Com)
            $obj.Document.Application.MinimizeAll()
        }

        elseif ($Method -Match "ServiceStop") {

            $Com = [Type]::GetTypeFromCLSID("C08AFD90-F2A1-11D1-8455-00A0C91F3880","$ComputerName")
            $Obj = [System.Activator]::CreateInstance($Com)
            $obj.Document.Application.ServiceStop("$ServiceName")
        }
        
        elseif ($Method -Match "ServiceStart") {

            $Com = [Type]::GetTypeFromCLSID("C08AFD90-F2A1-11D1-8455-00A0C91F3880","$ComputerName")
            $Obj = [System.Activator]::CreateInstance($Com)
            $obj.Document.Application.ServiceStart("$ServiceName")
        }
        elseif ($Method -Match "DetectOffice") {

            $Com = [Type]::GetTypeFromProgID("Excel.Application","$ComputerName")
            $Obj = [System.Activator]::CreateInstance($Com)
            $isx64 = [boolean]$obj.Application.ProductCode[21]
            Write-Host  $(If ($isx64) {"Office x64 detected"} Else {"Office x86 detected"})
        }
        elseif ($Method -Match "RegisterXLL") {

            $Com = [Type]::GetTypeFromProgID("Excel.Application","$ComputerName")
            $Obj = [System.Activator]::CreateInstance($Com)
            $obj.Application.RegisterXLL("$DllPath")
        }
        elseif ($Method -Match "ExcelDDE") {

            $Com = [Type]::GetTypeFromProgID("Excel.Application","$ComputerName")
            $Obj = [System.Activator]::CreateInstance($Com)
            $Obj.DisplayAlerts = $false
            $Obj.DDEInitiate("cmd", "/c $Command")
        }
    }

    End {

        Write-Output "Completed"
    }
    

}
