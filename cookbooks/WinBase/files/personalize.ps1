#
# Configure and setup stuff so the workstation will be ready to go when I log in
#

#windows has a start up routine when you first login, we need to wait until after that finishes.
write-host "waiting for Windows to settle down before personalizing."
Start-Sleep 60
Write-host "Personalizing"

#setup GIT
git config --global user.email "jake.watkins@dignityhealthcd.onmicrosoft.com"
git config --global user.name "Jake"

#set background wall paper
$MyWallpaper = "c:/users/sysadmin/pictures/laughing-man.jpg"
$code = @' 
using System.Runtime.InteropServices; 
namespace Win32{ 
    
    public class Wallpaper{ 
        [DllImport("user32.dll", CharSet=CharSet.Auto)] 
        static extern int SystemParametersInfo (int uAction , int uParam , string lpvParam , int fuWinIni) ; 
        
        public static void SetWallpaper(string thePath){ 
            SystemParametersInfo(20,0,thePath,3); 
        }
    }
} 
'@

add-type $code 
[Win32.Wallpaper]::SetWallpaper($MyWallpaper)

#see if the start menu has been done
# copy the start.bin file
$dir = get-item "C:\Users\sysAdmin\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_*"
copy-item "C:\chef\cache\cookbooks\WinBase\files\start.bin" "$dir\localstate\"

# all of the settings for VS are stored in a file located at: C:\Users\sysAdmin\AppData\Local\Microsoft\VisualStudio\17.0_*\Settings\CurrentSettings.vssettings
# customize VS, then save the file and add it to the cookbook's files and copy in to the correct place

# get the path to where the settings go
$vsLocalPath = get-item "C:\Users\sysAdmin\AppData\Local\Microsoft\VisualStudio\17*"
if ($vsLocalPath) {
    $vsSettings = ($vsLocalPath.FullName).ToString() + "\Settings"
    
    Copy-Item "C:\chef\cache\cookbooks\WinBase\files\VisualStudio-Settings.vssettings" "$vsSettings\CurrentSettings.vssettings"
}

# setup the database connections for SSMS
$sqlSettingsExist = test-path -path "C:\Users\sysAdmin\AppData\Roaming\Microsoft\SQL Server Management Studio\18.0\"
if ($sqlSettingsExist -eq $false) {
    mkdir "C:\Users\sysAdmin\AppData\Roaming\Microsoft\SQL Server Management Studio\18.0\"
}
Copy-Item "C:\temp\usersettings.xml" "C:\Users\sysAdmin\AppData\Roaming\Microsoft\SQL Server Management Studio\18.0\"

# change the VS templates for class to my version
# just put the templates in teh files and use the cookbook_File resource for this


#set chrome as the default browser
Add-Type -AssemblyName 'System.Windows.Forms'
Start-Process $env:windir\system32\control.exe -ArgumentList '/name Microsoft.DefaultPrograms /page pageDefaultProgram\pageAdvancedSettings?pszAppName=google%20chrome'
Start-Sleep 2
[System.Windows.Forms.SendKeys]::SendWait("{TAB} {TAB}{TAB} ")
