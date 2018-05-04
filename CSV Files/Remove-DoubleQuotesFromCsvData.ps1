param(
    [Parameter(Mandatory=$true,
        Position=0,
        ValueFromPipeline=$true)]
    [ValidateNotNullOrEmpty()]
    [string[]] $InputCsvData
)

$output = $InputCsvData | % { 
    $_ -replace '\G(?<start>^|,)(("(?<output>[^,"]*?)"(?=,|$))|(?<output>".*?(?<!")("")*?"(?=,|$))|(?<output>))' `
    ,'${start}${output}'
}

return $output
