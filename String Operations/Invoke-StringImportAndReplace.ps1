function Invoke-StringImportAndReplace {
    param(
        [Parameter(Mandatory=$true, ParameterSetName='StringInput')]
        [String] $InputString,

        [Parameter(Mandatory=$true, ParameterSetName='FilepathInput')]
        [String] $FilePath, 

        [Parameter(ParameterSetName='StringInput')]
        [Parameter(ParameterSetName='FilepathInput')]
        [Parameter(Mandatory = $false)]
        [Switch] $WholeWord,

        [Parameter(ParameterSetName='StringInput')]
        [Parameter(ParameterSetName='FilepathInput')]
        [Parameter(Mandatory = $true)]
        [Hashtable] $Replacments
    )

    $string_data = if ($($PSCmdlet.ParameterSetName) -eq "StringInput") 
            { $InputString }
        elseif ($($PSCmdlet.ParameterSetName) -eq "FilepathInput") 
            { Get-Content "$FilePath" -Raw }


    $Replacments.GetEnumerator() | ForEach-Object {

        $expression = "$($_.Key)"
        if ($WholeWord) { $expression += '\b' }

        $string_data = $string_data -replace "$expression", "$($_.Value)"

    }

    return $string_data

}