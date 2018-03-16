function Create-AdTestGroups {

	param (
		
		# Group count
		[Parameter(Mandatory=$true)]
		[ValidateScript({$_ -ge 1})]
		[int] $Count,

		# The DN of the OU where the user created groups will be dumped
		[Parameter(Mandatory=$true)]
		[String] $Path,

		# The name each group created will be based from 
		[Parameter(Mandatory=$false)]
		[String] $BaseName="TestGroup"

	)

	$name = "TestGroup"

	for($i=1; $i -le $Count; $i++) {
		
		if ($i -lt 10) {$itt = "0$($i)"} else {$itt = $i} 

		$parameters = @{
			"GroupCategory" = "Security"
			"GroupScope" = "Universal"
			"Name" = "$($itt)_$($BaseName)$itt"
			"DisplayName" = "$($BaseName)$itt"
			"path" = "$Path"
		}

		New-ADGroup @parameters

	}

}