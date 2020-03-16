# https://docs.microsoft.com/en-us/nuget/create-packages/sign-a-package#create-a-test-certificate

# taskPath
# e.g. - D:\github\vsts-agent\src\Test\L1\Tasks\SignedTaskCertA
function ZipTaskFolder($taskPath) {
    Write-Host "Zipping task folder"

    # e.g. - D:\github\vsts-agent\src\Test\L1\Tasks
    $parentDirectory = [System.IO.Path]::GetDirectoryName($taskPath)

    # e.g. - SignedTaskCertA
    $taskDirectoryName = Split-Path $taskPath -Leaf

    # e.g - D:\github\vsts-agent\src\Test\L1\Tasks\SignedTaskCertA.zip
    $zipPath = $parentDirectory + "\" + $taskDirectoryName + ".zip"

    # Fully qualified path to all files in the flder
    $filesInFolder = (Get-ChildItem $taskPath -Recurse).fullname

    Compress-Archive -LiteralPath $filesInFolder -DestinationPath $zipPath -Force
}

function GenerateSignature() {
    Write-Host "Generating signature"

    $friendlyName = "NuGetTestCertTaskSigning-" + (Get-Random)
    Write-Host $friendlyName

    New-SelfSignedCertificate -Subject "CN=NuGet Test Developer, OU=Use for testing purposes ONLY" `
                            -FriendlyName $friendlyName `
                            -Type CodeSigning `
                            -KeyUsage DigitalSignature `
                            -KeyLength 2048 `
                            -KeyAlgorithm RSA `
                            -HashAlgorithm SHA256 `
                            -Provider "Microsoft Enhanced RSA and AES Cryptographic Provider" `
                            -CertStoreLocation "Cert:\CurrentUser\My"

    # Print out fingerprint
}


GenerateSignature
# ZipTaskFolder(Resolve-Path $args[0])








# Write-Host "Signing task"

# rename
# sign
# rename back




