function Test-AdCredentials {
	
	param (
		[Parameter(Mandatory = $true)]
		[System.Management.Automation.PSCredential]
		$Credentials
	)

    $this_domain = "LDAP://" + ([ADSI]"").distinguishedName
    $this_domain_connected = New-Object System.DirectoryServices.DirectoryEntry($this_domain, $($Credentials.UserName), $($Credentials.GetNetworkCredential().Password))
    
    if ( $this_domain_connected.name ) 
	{ return $true } else { return $false }
	
}