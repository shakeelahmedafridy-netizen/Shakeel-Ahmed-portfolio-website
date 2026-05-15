$body = '{"service_id":"service_q6a00ub","template_id":"template_ftox4ik","user_id":"eI4Ufs1_fyHZNeddv","template_params":{"from_name":"Test User","from_email":"test@test.com","reply_to":"test@test.com","to_email":"shakeelahmedafridy@gmail.com","name":"Test User","email":"test@test.com","phone":"0300-1234567","subject":"Test","message":"Test message","time":"7 May 2026"}}'

Write-Host "=== EmailJS API Test ===" -ForegroundColor Cyan
Write-Host "Sending to EmailJS..." -ForegroundColor Yellow

try {
    $response = Invoke-WebRequest `
        -Uri "https://api.emailjs.com/api/v1.0/email/send" `
        -Method POST `
        -Body $body `
        -ContentType "application/json" `
        -ErrorAction Stop

    Write-Host ""
    Write-Host "SUCCESS!" -ForegroundColor Green
    Write-Host "Status Code: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "Response: $($response.Content)" -ForegroundColor Green
}
catch {
    $statusCode = [int]$_.Exception.Response.StatusCode
    Write-Host ""
    Write-Host "FAILED!" -ForegroundColor Red
    Write-Host "Status Code: $statusCode" -ForegroundColor Red

    try {
        $stream = $_.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($stream)
        $errorBody = $reader.ReadToEnd()
        Write-Host "Error Body: $errorBody" -ForegroundColor Red
    } catch {
        Write-Host "Error Message: $($_.Exception.Message)" -ForegroundColor Red
    }

    switch ($statusCode) {
        400 { Write-Host "FIX: Template variables mismatch in EmailJS dashboard" -ForegroundColor Yellow }
        401 { Write-Host "FIX: Wrong Public Key - check EmailJS account" -ForegroundColor Yellow }
        404 { Write-Host "FIX: Wrong Service ID or Template ID" -ForegroundColor Yellow }
        412 { Write-Host "FIX: Gmail disconnected - Re-authenticate in EmailJS dashboard" -ForegroundColor Yellow }
        422 { Write-Host "FIX: Template variables missing" -ForegroundColor Yellow }
        429 { Write-Host "FIX: Too many requests - wait 1 minute" -ForegroundColor Yellow }
    }
}
