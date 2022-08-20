# get the path to where the settings go
$vsLocalPath = get-item "C:\Users\sysAdmin\AppData\Local\Microsoft\VisualStudio\17*"
if ($vsLocalPath) {
    $vsSettings = ($vsLocalPath.FullName).ToString() + "\Settings"
    
    Copy-Item "C:\chef\cache\cookbooks\WinBase\files\VisualStudio-Settings.vssettings" "$vsSettings\CurrentSettings.vssettings"
}
