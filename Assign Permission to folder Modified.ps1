 <#
        .SYNOPSIS
        Assign Permission to folder under the shared path.

        .DESCRIPTION
        This script will Assign Permission to a folder under the share path.

        .PARAMETER Name
        sharePathUrl
        UserId
        permissionType
        inheritence

        .INPUTS
        sharePathUrl
        UserId
        permissionType
        inheritence

        .OUTPUTS
        Assigned Permission log

        .VERSION
        1.0

        .DEVELOPER
        vRO Automation Team
    #>

try
{
    #Inputs
	$sharePathUrl = 'D:\CLP-Test'
    $userName = 'Avmed\vbisht'
    $permissionType = 'FullControl'
    $inheritence = "Yes"


    Function Assign-Permission
    {
        param (
            [Parameter(Mandatory)]
            $sharePathUrl,

            [Parameter(Mandatory)]
            $UserName,

            [Parameter(Mandatory)]
            $permissionType,

            [Parameter(Mandatory)]
            $inheritence
        )

        try
        {
            #Check if the path is present
 
                if(Test-Path -Path "$sharePathUrl")
                {
                    #Assigning the provided permission to folder with respected user.
                    "Allowing user $UserId with the provided permission on folder $sharePathUrl on share path $sharePathUrl."
                    $Acl = Get-Acl -Path $sharePathUrl
                    if($inheritence -eq "Yes")
                    {
                        $NewAccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($UserName,$permissionType,"3","0","Allow")
                    }
                    else
                    {
                        $NewAccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($UserName,$permissionType,"Allow")
                    }
                    $Acl.SetAccessRule($NewAccessRule)
                    $Acl | Set-Acl -Path $sharePathUrl
                    $out = (Get-Acl -Path $sharePathUrl).Access | Format-Table identityReference,FileSystemRights,AccessControlType,IsInherited,InheritanceFlags -AutoSize

                }
                else
                {
                    throw "Share Path $sharePathUrl not present."
                    
                }
        }
        catch
        {
            throw "Error occured in the function 'Assign-Permission'. Error : $($_.Exception)"
        }
    }
    Assign-Permission -sharePathUrl $sharePathUrl -UserName $userName -permissionType $permissionType -inheritence $inheritence
}
catch
{
    throw "Error occured in the scripts $($_.Exception)"
}