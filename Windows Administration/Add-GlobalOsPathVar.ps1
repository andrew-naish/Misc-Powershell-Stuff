function Add-GlobalOsPathVar($NewPath) {

    # Verification
    if (!(Test-Path $NewPath)) {
        Write-Host "Dat Path.." -ForegroundColor Red
        break
    }

    # Get Current State
    #$currPathVar = $env:Path
    # Get Current State
    $currPathVar = (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).Path
    
    # Valiate
    $currPathVar_spl = $currPathVar -split ';'
    if ($currPathVar_spl -contains $NewPath) {
        Write-Host "That path is already in the PathVar" -ForegroundColor Yellow
        Break
    }

    # Apply
    # $env:Path += ";$NewPath"
    # Construct New, Apply
    $newPathVar = $currPathVar + ’;’ + $NewPath
    Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH –Value $newPathVar 

    # Broadcast Change - So it doesn't require a reboot
    if (-not ("win32.nativemethods" -as [type])) {
    # import sendmessagetimeout from win32
    Add-Type -Namespace Win32 -Name NativeMethods -MemberDefinition @"
		[DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
		public static extern IntPtr SendMessageTimeout(
			IntPtr hWnd, uint Msg, UIntPtr wParam, string lParam,
			uint fuFlags, uint uTimeout, out UIntPtr lpdwResult);
"@
	}
	
    $HWND_BROADCAST = [intptr]0xffff;
    $WM_SETTINGCHANGE = 0x1a;
    $result = [uintptr]::zero

    [win32.nativemethods]::SendMessageTimeout($HWND_BROADCAST, $WM_SETTINGCHANGE,
	    [uintptr]::Zero, "Environment", 2, 5000, [ref]$result) | Out-Null

}