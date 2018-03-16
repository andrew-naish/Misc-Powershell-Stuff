function Create-AdTestUsers {

	param (

		# User count
		[Parameter(Mandatory=$true)]
		[ValidateScript({$_ -ge 1})]
		[int] $Count,

		# The DN of the OU where the created users will be dumped
		[Parameter(Mandatory=$true)]
		[String] $Path,

		# The domaich which will become the end of each users' UPN and email
		[Parameter(Mandatory=$true)]
		[String] $BaseDomain,

		# The firstname each user created will be based from 
		[Parameter(Mandatory=$false)]
		[String] $BaseFirstname="John",
	
		# The firstname each user created will be based from 
		[Parameter(Mandatory=$false)]
		[String] $BaseSurname="Smith"

	)

	for($i=1; $i -le $Count; $i++) {
		
		if ($i -lt 10) {$itt = "0$($i)"} else {$itt = $i} 

		$secureStrPwd = ConvertTo-SecureString -AsPlainText "Password$itt" -Force
		$upnAndMail = "$($BaseFirstname).$($BaseSurname)$itt@$BaseDomain"

		$parameters = @{
			"GivenName" = "$BaseFirstname" 
			"Surname" = "$($BaseSurname)$itt" 
			"Name" = "$($itt)_$($BaseFirstname) $($BaseSurname)$itt"
			"DisplayName" = "$($BaseFirstname) $($BaseSurname)$itt"
			"SamAccountName" = "$($BaseFirstname)$($BaseSurname)$($itt)"
			"UserPrincipalName" = "$upnAndMail"
			"Emailaddress" = "$upnAndMail"
			"AccountPassword" = $secureStrPwd
			"enabled" = $True
			"path" = "$Path"
		}

		New-ADUser @parameters -PasswordNeverExpires:$True

	}

}