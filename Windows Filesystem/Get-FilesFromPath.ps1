function Get-FileSystemEntries {

    param(
        
        # The path from which to start searching from ($pwd by default)
        [Parameter(Mandatory=$false)]
        [ValidateScript({ 
            if ( !(Test-Path $_)) { throw "Invalid path specified" } 
            else { return $true }
        })]
        [String] $FromPath='.',

        # See remarks: https://msdn.microsoft.com/en-us/library/dd383460(v=vs.110).aspx 
        [Parameter(Mandatory=$false)]
        [String[]] $Filter='*',

        # Recurseive search? - false by default
        [Parameter(Mandatory=$false)]
        [Switch] $Recurse

    )

    $FromPath = Resolve-Path "$FromPath"
    $ShouldRecurse = if ($Recurse) {[System.IO.SearchOption]::AllDirectories}
        else {[System.IO.SearchOption]::TopDirectoryOnly}
    
    $to_return = New-Object System.Collections.Generic.List[System.String]

    $Filter | ForEach-Object {
        $to_return.AddRange( [System.IO.Directory]::EnumerateFileSystemEntries($FromPath, $_, $ShouldRecurse) )
    }

    return $to_return

}