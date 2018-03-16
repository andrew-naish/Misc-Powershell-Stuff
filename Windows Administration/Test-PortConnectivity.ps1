function Test-Port ($Address, [int]$Port, $Timeout=3000) {
    $tcpobject = New-Object System.Net.Sockets.TcpClient
    
    try {
        
        $connect = $tcpobject.BeginConnect($Address,$Port,$null,$null)
        $wait = $connect.AsyncWaitHandle.WaitOne($Timeout,$false)
        
        # Timeout
        if (!$wait) {
            
            throw "Timeout"
            
        } else {
            
            $tcpobject.EndConnect($connect)
            return $true
            
        }
    } 
    
    catch   { return $false }
    finally { $tcpobject.Close() }   
}