param(
    [string]$address,
    [string]$timeout = "15", # 默认超时时间为15秒
    [int]$Interval = 10 # 默认间隔时间为5秒
    
)

function Test-Connection {
    param(
        [string]$IpAddress,
        [int]$Port,
        [int]$WaitTimeout
    )
    try {
        $tcpClient = New-Object System.Net.Sockets.TcpClient
        $asyncResult = $tcpClient.BeginConnect($IpAddress, $Port, $null, $null)
        $result = $asyncResult.AsyncWaitHandle.WaitOne($WaitTimeout * 1000, $false)
        $tcpClient.Close()
        return $result
    }
    catch {
        return $false
    }
}
$addressArr = $address.Split(':')
$IpAddress = $addressArr[0]
$Port = $addressArr[1]
$WaitTimeout = 0
if ($timeout -match "--timeout=(\d+)") {
    $WaitTimeout = [int]$Matches[1]
}
else {
    $WaitTimeout = 0
}

while ($true) {
    $result = Test-Connection -IpAddress $IpAddress -Port $Port -WaitTimeout $WaitTimeout
    if ($result) {
        Write-Host "${IpAddress}:$Port is accessible."
        break
    }
    else {
        Write-Host "${IpAddress}:$Port is not accessible. Retrying in $Interval seconds..."
        Start-Sleep -Seconds $Interval
    }
}