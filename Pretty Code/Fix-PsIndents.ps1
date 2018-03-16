param(
    [Parameter(Mandatory=$true)]
    [String] $Path,

    [Parameter(Mandatory=$false)]
    [Switch] $NoBackup
)

# Init

$indentChar = "    " # 4 spaces
$Path = (Resolve-Path $path).path
$tempPath = "$(Split-Path $Path -Resolve)\temp.ps1"
$ErrorActionPreference = "Stop"

function Make-Indent([string]$Padding=$indentChar,[int]$Level) {
   [string]$return = $Padding * $Level
    return $return
}

# Main

try {
    
    $file = Get-Content -Path $Path
    $streamWriter = [System.IO.StreamWriter] "$tempPath"
    [int]$iindentLevel = 0

    foreach ($line in $file) {
        
        # trim leading/trailing whitespace
        $lineContent = [string]$line.Trim()

        # '}' after whitespace or if there are things after it (the '} else {' situation)
        if ( [regex]::IsMatch($lineContent,"^([\s*])?}(.+)?$") )
        {if ($iindentLevel -ge 0) {$iindentLevel--}}
    
        $iindent = Make-Indent -Level $iindentLevel
        $newLine = "{0}{1}" -f $iindent, $lineContent

        # '{' on the end of a line
        if ( [regex]::IsMatch($lineContent,"{( +?#.+)?$") ) 
        {$iindentLevel++}

        $streamWriter.WriteLine($newLine)

    }

    $streamWriter.Close()

    # backup the dirty file
    if (!$NoBackup) {
        
        if (Test-Path "$Path-old")  {  
            throw "there is an existing backup please check & delete if neccessary"
        }

        Rename-Item -Path $Path -NewName "$Path-old" -Force

    }
    
    # .. or don't
    else { Remove-Item -Path $Path }

    # the ol' switcharoo
    Rename-Item -Path $tempPath -NewName $Path

}

catch {
    
    $thisError = $error[0]

    Write-Host "An error occured: " -ForegroundColor Red
    Write-Host "-----" -ForegroundColor Yellow
    Write-Host "Type    : $($thisError.GetType().Fullname)" -ForegroundColor Red
    Write-Host "Message : $($thisError.Exception.Message)" -ForegroundColor Red

}

finally {

    # and again .. just incase
    $streamWriter.Close()

} 