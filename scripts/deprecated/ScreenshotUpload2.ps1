
$user = 'deantammam@icloud.com'
$pass = 'Doyouwanttobuildasnowman6^'
$pair = "$($user):$($pass)"

$encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))

$basicAuthValue = "Basic $encodedCreds"

$Headers = @{
    Authorization = $basicAuthValue
    Origin = 'https://www.icloud.com/'
}






$File = "C:\WOWOWOWOW.jpg"
$uri = "https://p24-uploadimagews.icloud.com/upload?filename=$($File)"


$test = Invoke-WebRequest -uri $uri -Method Options -UseBasicParsing -Headers @{ "Origin" = 'https://www.icloud.com' }.Headers -UserAgent "PowerShell"

$test
$headerarray = @($test.Headers)
$headerarray

$headerarray.remove('Connection')
$headerarray


<#$headers = $test.Headers
$jingle = $headers.'X-Apple-Jingle-Correlation-Key'
$jingle
#>

# Invoke-WebRequest -uri $uri -Method Options -Infile $File -ContentType 'image/jpg' -Headers $Test.Headers
Invoke-WebRequest -uri $uri -Method Post -Infile $File -ContentType 'image/jpg' -Headers $Test.Headers




