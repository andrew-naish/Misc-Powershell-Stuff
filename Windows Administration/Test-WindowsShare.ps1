function Test-SMBConnection ($ComputerName) {
    [boolean]$connected = $false
    $dName = "V" 

    New-PSDrive -Name "$dName" -PSProvider FileSystem -Root "\\$ComputerName\c$" -Persist -ErrorAction SilentlyContinue | Out-Null

    if (Get-PSDrive -Name $dName -ErrorAction SilentlyContinue) {
        $connected = $true
    }

    Remove-PSDrive "$dName" -ErrorAction SilentlyContinue

    return $connected
}