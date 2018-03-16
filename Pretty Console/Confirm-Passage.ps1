function Confirm-Passage([string]$Message, [switch]$UseCatapha) {

    $passage_granted = $false
    $catapha_prefix = "Muffin" #left this here for easy cnhageability

    if ($UseCatapha) {

        $catapha_word = "{0}{1}" -f $catapha_prefix, (100..999 | Get-Random)
        do {
            if ($Message) {Write-Host $Message}
            Write-Host "Please type " -NoNewline
                Write-Host "$catapha_word" -ForegroundColor Cyan -NoNewline
                    Write-Host " to continue: " -NoNewline
            
            switch (Read-Host) {
                default {
                    Write-Host "Invalid, please try again." -ForegroundColor Red
                }
                "$catapha_word" { $passage_granted = $true }
            }

        } 
        while ($passage_granted -eq $false)
    }

    else {
        $message_to_use = if ($Message) {$Message} else {
            "Do you wish to continue?"
        }

        do {
        Write-Host "$message_to_use" -NoNewline
            Write-Host " [Y/N]: " -ForegroundColor Cyan -NoNewline
        
            switch (Read-Host) {
                default {
                    Write-Host "Invalid, please respond with either Y(yes) or N(no)" -ForegroundColor Red
                }
                "Y" {$passage_granted = $true}
                "N" {Exit}
            }
        }
        while ($passage_granted -eq $false)
    }

}
