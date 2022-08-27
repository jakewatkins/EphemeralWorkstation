#
# Backup the repos in the \Source directory
#

#login to Azure using the service principal so we can push the archives to a blob container
$accountName = "jkwfiles"
$accountKey = ""  #this should be pulled from a keyvault or from the storage acount
$container = "archive"
$base = Get-Date -Format "yyyymmddhh"

$repos = Get-ChildItem -Path c:\source\ -Directory
foreach ($folder in $repos) {
    $archiveName = "c:\source\$folder-$base.zip"
    Compress-Archive -Path "C:\source\$folder" -DestinationPath $archiveName
    az storage blob upload -f $archiveName -c $container --account-name $accountName --account-key $accountKey
}



