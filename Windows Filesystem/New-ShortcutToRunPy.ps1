function CreateWindowsShortcut ($SourceExe, $ArgumentsToSourceExe, $DestinationPath) {
    $WshShell = New-Object -comObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($DestinationPath)
    $Shortcut.TargetPath = $SourceExe
    $Shortcut.Arguments = $ArgumentsToSourceExe
    $Shortcut.Save()
}

Get-ChildItem -File -Recurse -Filter "*.py" | ForEach-Object {

    $file_name = $_.name

    $args = "-NoLogo -NoExit -NoProfile -Command py.exe $file_name"
    $destination = Join-Path $(Split-Path $($_.FullName) -Parent) "Run Script - $file_name.lnk"

    CreateWindowsShortcut -SourceExe "Powershell.exe" `
        -ArgumentsToSourceExe "$args" `
        -DestinationPath $destination

    Write-StepNotes "created shortcut: $destination"

}
