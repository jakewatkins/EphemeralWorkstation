#
# Download and install Visual Studio 2022
#

# download the installer
$source = "https://jkwfiles.blob.core.windows.net/bootstrap/VisualStudioSetup.exe?sp=r&st=2022-06-27T13:27:40Z&se=2024-01-01T22:27:40Z&spr=https&sv=2021-06-08&sr=b&sig=6q%2FPrBA6zluywNm5lHBZsEwCMDsJ%2FTRcB0Z6GprWoAw%3D"
$destination = "C:\chef\cache\cookbooks\WinBase\files\VisualStudioSetup.exe"
Invoke-WebRequest -uri $source -OutFile $destination

start-process -FilePath "C:\chef\cache\cookbooks\WinBase\files\VisualStudioSetup.exe" -ArgumentList "--add Microsoft.VisualStudio.Workload.Azure --add Microsoft.VisualStudio.Workload.ManagedDesktop --add Microsoft.VisualStudio.Workload.NetWeb  --includeRecommended --includeOptional --quiet --norestart" -Wait

