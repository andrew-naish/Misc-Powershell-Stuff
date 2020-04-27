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

function New-ConsoleRibbon () {
    param(
        [Parameter(Mandatory=$true, Position=1)]
        [String] $Message,

        [Parameter(Mandatory=$false)]
        [Char] $RibbonChar="=",

        [Parameter(Mandatory=$false)]
        [Switch] $SingleLine
    )

    $console_width = ($Host.UI.RawUI.WindowSize.Width)-1

    # construct full lines
    
    [string]$full_line = ""
    for ($i=0; $i -lt $console_width; $i++) {
        $full_line = $full_line + $RibbonChar
    }

    # construct padding
    
    $message_length = $Message.Length
    $padding_length = (($console_width-$message_length)/2)-1
    
    [string]$padding = ""
    for ($i=0; $i -lt $padding_length; $i++) {
        $padding = $padding + " "
    }

    # return 
    
    if ($SingleLine)
    {
        $half_line  = ""
        for ($i=0; $i -lt $padding_length-2; $i++) {
            $half_line = $half_line + $RibbonChar
        }
        Write-Host "$(" {0} $Message {0}{1}{1}" -f $half_line, $RibbonChar)"
    } 

    else 
    {
        Write-Host $full_line
        Write-Host ""
        Write-Host ("{0}$Message" -f $padding)
        Write-Host ""
        Write-Host $full_line
    }

    Write-Host ""

}