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

New-ConsoleRibbon -Message "Fishcake"