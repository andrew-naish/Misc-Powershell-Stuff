#requires -version 5.0

using namespace System.Security.AccessControl
using namespace System.Security.Principal

function Test-ADAccount ($SamAccountName) {

    $result = $false
    $sam = New-Object NTAccount("$SamAccountName")

    try {
    $sam_as_sid = $sam.Translate([SecurityIdentifier])
    $result = $sam_as_sid.IsAccountSid()
    } catch [IdentityNotMappedException] {}

    return $result

}

function Set-RecursiveAcl {

    param (

        # The SamAccountName of the user or group
        [Parameter(Mandatory=$true)]
        [ValidateScript({ 
            if ( !(Test-ADAccount $_)) { throw "The account does not exist" }
            else { return $true }
        })]
        [String] $UserId,

        # The path to the FileSytemObject
        [Parameter(Mandatory=$true)]
        [ValidateScript({ 
            if ( !(Test-Path $_)) { throw "Invalid path specified" } 
            else { return $true }
        })]
        [String] $Path,

        # Whether this is an Allow or Deny rule
        [Parameter(Mandatory=$true)]
        [ValidateSet('Allow','Deny')]
        [String] $AccessType="Allow",

        # The type of access ti grant (or deny) the user
        [Parameter(Mandatory=$true)]
        [ValidateSet('FullControl','Modify','Read','ReadAndExecute','Write')]
        [String[]] $AccessRights="Read",

        # apply permissions only to chidren (sub files and directories) of the Path
        [Parameter(Mandatory=$false)]
        [Switch] $ChildrenOnly,

        # Return message or boolean
        [Parameter(Mandatory=$false)]
        [ValidateSet('Message', 'Boolean', 'Both')]
        [String] $ReturnType = "Both"

    )
    
    ## Init
    
    $is_directory = (Get-Item $Path) -is [System.IO.DirectoryInfo]
    $outcome_status = $false

    ## Input

    $user_sam = New-Object NTAccount("$UserId")
    $acr_flag_access_type  = [AccessControlType]::$($AccessType)

    # static to enable recursion
    $acr_flag_inheritance = [InheritanceFlags]$(if ($is_directory) {"ObjectInherit,ContainerInherit"} else {"None"} )
    $acr_flag_propagation = [PropagationFlags]::$( if ($ChildrenOnly) {"InheritOnly"} else {"None"} )

    ## Main

    # get current acl
    $current_acl = Get-ACL "$Path" 

    # remove current record from acl if present
    $user_in_current_acl = $current_acl.GetAccessRules( $true, $false, [System.Security.Principal.NTAccount] ) | 
        Where-Object {  $_.IdentityReference.Value -like "*$UserId*"  } | Select-Object
    if ( $user_in_current_acl ) { $nulll = $current_acl.RemoveAccessRule($user_in_current_acl) }

    # buuld new acl rule
    foreach ( $right in $AccessRights ) {

        $acr_flag_rights = [FileSystemRights]"$right"

        $new_access_ctrl_rule = New-Object FileSystemAccessRule($user_sam,
                                                                $acr_flag_rights, 
                                                                $acr_flag_inheritance, 
                                                                $acr_flag_propagation, 
                                                                $acr_flag_access_type) 
        $current_acl.AddAccessRule($new_access_ctrl_rule)

    }

    # apply

    try {
        Set-ACL "$Path" $current_acl

        $outcome_status = $true
        $outcome_message = "Successfully updated ACL"
    } catch { 
        $outcome_message = "Failed to apply ACL"
    }

    ## Outptut

    $outcome_message = "$outcome_message For: $Path"

    # there's got to be a better way ..
    switch ($ReturnType) {
        "Message" {
            Write-Output $outcome_message
        }
        "Boolean" {
            return $outcome_status
        }
        "Both" {
            Write-Output $outcome_message
            return $outcome_status
        }
    }

}
