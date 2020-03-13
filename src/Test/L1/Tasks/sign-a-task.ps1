# https://docs.microsoft.com/en-us/nuget/create-packages/sign-a-package#create-a-test-certificate

# e.g. - D:\github\vsts-agent\src\Test\L1\Tasks\SignedTaskCertA
$taskPath = Resolve-Path $args[0]

Write-Host "Zipping task folder "

# e.g. - D:\github\vsts-agent\src\Test\L1\Tasks
$parentDirectory = [System.IO.Path]::GetDirectoryName($taskPath)

# e.g. - SignedTaskCertA
$taskDirectoryName = Split-Path $taskPath -Leaf

# e.g - D:\github\vsts-agent\src\Test\L1\Tasks\SignedTaskCertA.zip
$zipPath = $parentDirectory + "\" + $taskDirectoryName + ".zip"


# Write-Host ($Files = @(Get-ChildItem -Path $taskPath))
$filesInFolder = (Get-ChildItem $taskPath -Recurse).fullname

# $compress = @{
#     LiteralPath = $filesInFolder 
#     DestinationPath = $zipPath
# }
Compress-Archive -LiteralPath $filesInFolder -DestinationPath $zipPath -Force
#Compress-Archive -Path $taskPath -DestinationPath $zipPath

Write-Host "Generating signature"

# New-SelfSignedCertificate -Subject "CN=NuGet Test Developer, OU=Use for testing purposes ONLY" `
#                           -FriendlyName "NuGetTestDeveloper" `
#                           -Type CodeSigning `
#                           -KeyUsage DigitalSignature `
#                           -KeyLength 2048 `
#                           -KeyAlgorithm RSA `
#                           -HashAlgorithm SHA256 `
#                           -Provider "Microsoft Enhanced RSA and AES Cryptographic Provider" `
#                           -CertStoreLocation "Cert:\CurrentUser\My"

# Write-Host "Signature generated"

# Print out fingerprint


# Write-Host "Signing task"

# rename
# sign
# rename back




