function Shuffle-AdGroupMembership {
	
	param(
		
		# The DN of the OU containing groups whos members will be shuffled
		[Parameter(Mandatory=$true, Position=1)]
		[String] $GroupsOU,

		# The DN of the OU where users will be selected from
		[Parameter(Mandatory=$true, Position=2)]
		[String] $UserPoolOU,

		# Min amount of users that can be added to a group
		[Parameter(Mandatory=$true, Position=3)]
		[ValidateScript({$_ -ge 1})]
		[int] $MinimmumUsersInGroup,

		# Max amount of users that can be added to a group
		[Parameter(Mandatory=$true, Position=4)]
		[ValidateScript({$_ -gt $MinimmumUsersInGroup})]
		[int] $MaximmumUsersInGroup

	)
	
	## Init 

	$groups = Get-ADGroup -Filter * -SearchBase "$GroupsOU"

	function AddTo-ADGroupFromUserPool ($GroupName, $Min, $Max, $UserPoolOU) {
		
		$group = Get-ADGroup $GroupName
		$userPool = (Get-ADUser -Filter * -SearchBase $UserPoolOU).distinguishedName
		$choice = Get-Random -Minimum $Min -Maximum $Max

		# clear existing members
		$members = (Get-ADGroupMember $group).distinguishedName
		if ($members) { # .. only if not empty
			$group | Remove-ADGroupMember -Members $members -Confirm:$false
		}

		# select & add users to group
		for ($i=1; $i -lt $choice; $i++) {
			
			$theChosenOne = $userPool | Get-Random
			$group | Add-ADGroupMember -Members $theChosenOne

		}

	}

	## Main

	$groups | ForEach-Object {

		AddTo-ADGroupFromUserPool -GroupName $_.name `
			-Min $MinimmumUsersInGroup -Max $MaximmumUsersInGroup `
			-UserOUPool $UserPoolOU

	}

}
