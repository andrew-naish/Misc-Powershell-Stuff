function Get-RegKeyAsHashtable { 

    param (

        # Registry Key path
        [Parameter(Mandatory=$true)]
        [ValidateScript({ 
            if ( !(Test-Path $_)) { throw "Invalid path specified" } 
            else { return $true }
        })]
        [String] $Path

    )

    $regkey_properties = ( Get-ItemProperty $Path ).PSBase.Properties | 
        Where-Object { $_.Name -inotlike "PS*" }
    $return = @{}

    $regkey_properties | ForEach-Object {  
        $return.Add("$($_.Name)", "$($_.Value)") 
    } 
    
    return $return 

}