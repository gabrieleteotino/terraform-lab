[PSCustomObject]@{
    address = (Invoke-WebRequest -uri "http://ifconfig.me/ip").Content
} | ConvertTo-Json