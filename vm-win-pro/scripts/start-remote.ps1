$username = '.\sysadmin'
$password = ConvertTo-SecureString -string 'P@ssw0rd1234!' -AsPlainText -Force

$credential = new-object -TypeName system.management.automation.pscredential -ArgumentList ($username, $password)

enter-pssession -ComputerName vm-jkw-ws-sprinter.centralus.cloudapp.azure.com -Credential $credential