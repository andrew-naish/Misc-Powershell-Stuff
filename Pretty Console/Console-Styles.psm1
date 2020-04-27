function Write-Header {
    param(
        [Parameter(Mandatory=$true)]
        [String] $FallbackMsg
    )
    
    $p = Resolve-Path ".\resource\header.txt"
    Write-Host ""

    if ((Test-Path "$p")) {
        $c = [System.IO.File]::ReadAllText("$p")
        Write-Host "$c"
    } else { Write-Host "$FallbackMsg"}
}

function Write-StepHeading {
    param(
        [Parameter(Mandatory=$true, Position=1)]
        [String] $Message,

        [Parameter(Mandatory=$false)]
        [Int] $Level=1
    )

    Write-Host ""

    Switch ($Level) {
        1 { Write-Host ":: $Message" -ForegroundColor Yellow }
        2 { Write-Host "$Message" -ForegroundColor Magenta }
        default { Write-Host "$Message" }
    }

    # Write Marker for stepnotes
    $SCRIPT:isFirstNote = $true
}

function Write-StepNotes {
    param(
        [Parameter(Mandatory=$true, Position=1)]
        [String] $Message,

        [Parameter(Mandatory=$false)]
        [ValidateSet('Message','ErrorMessage')]
        [String] $Stream="Message"
    )

    # Decide if should put space
    if ($SCRIPT:isFirstNote) 
    { Write-Host ""; $SCRIPT:isFirstNote = $false }

    Switch ($Stream) {
        'Message'      { Write-Host " - $Message" -ForegroundColor DarkGray }
        'ErrorMessage' { Write-Host " > ERROR: $Message" -ForegroundColor Red }
    }
}

function New-ConsoleRibbon ([string]$Message, [switch]$SingleLine) {

    $lineChar = "="
    $paddingChar = " "
    $consoleWidth = ($Host.UI.RawUI.WindowSize.Width)-1

    # construct full lines
    
    [string]$fullLine = ""
    for ($i=0; $i -lt $consoleWidth; $i++) {
        $fullLine = $fullLine + $lineChar
    }

    # construct padding
    
    $msgLength = $Message.Length
    $paddingLength = (($consoleWidth-$msgLength)/2)-1
    
    [string]$padding = ""
    for ($i=0; $i -lt $paddingLength; $i++) {
        $padding = $padding + $paddingChar
    }

    # return 
    
    if ($SingleLine) {
        Write-Output $fullLine
        return
    }
    
    Write-Output $fullLine
    Write-Output ""
    Write-Output ("{0}$Message" -f $padding)
    Write-Output ""
    Write-Output $fullLine
    Write-Output ""

}