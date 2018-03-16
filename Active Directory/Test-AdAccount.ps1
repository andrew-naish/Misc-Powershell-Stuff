#requires -version 5.0
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
