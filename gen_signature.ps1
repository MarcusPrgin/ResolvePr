$secret = "04000de95405bad1a7a4feaa3e4c9db9e19c8ed64900ee42215909af5b552e17"
$body = "{}"
$secretBytes = [System.Text.Encoding]::UTF8.GetBytes($secret)
$bodyBytes = [System.Text.Encoding]::UTF8.GetBytes($body)

$hmac = [System.Security.Cryptography.HMACSHA256]::new()
$hmac.Key = $secretBytes
$hash = $hmac.ComputeHash($bodyBytes)
$signature = ($hash | ForEach-Object { $_.ToString("x2") }) -join ''
Write-Host "Valid signature: sha256=$signature"
