function Merge-CsvFiles {
    [CmdletBinding()]
    param(
        [Parameter(Position=1, Mandatory=$true, ValueFromPipeline=$true)]
        [String[]] $CsvFilePaths,

        [Parameter(Mandatory=$false, HelpMessage="If this is left null, output will be string")]
        [ValidateScript({Test-Path (Split-Path -Parent -Path ([IO.Path]::GetFullPath("$_")))})]
        [String] $OutputPath = "0"
    )

    Begin {
        $should_write_file = if ($OutputPath -eq "0") { $false } else { $true }
        $out_file = "$env:temp\blah.csv"
        $script:first = $true

        # initiate writings
        $io_writer = New-Object System.IO.StreamWriter ($out_file)
    }

    Process {

        $io_reader = New-Object System.IO.StreamReader ($CsvFilePaths)
        $csv_header = $io_reader.ReadLine()

        # if first file, use the header
        if ($script:first) {
            $io_writer.WriteLine($csv_header)
            $script:first = $false
        }

        # the rest ..
        while (($csv_line = $io_reader.ReadLine()) -ne $null) {
            $io_writer.WriteLine($csv_line)
        }

        $io_reader.Close()
        $io_reader.Dispose()
    }

    End {

        $io_writer.Close()

        if ( $should_write_file )
        { 
            Move-Item $out_file -Destination $OutputPath -Force
        }  
        else 
        {
            Get-Content -ReadCount 0 -Raw -Path $out_file
            Remove-Item $out_file -Force
        }

        $io_writer.Dispose()
    }
}
