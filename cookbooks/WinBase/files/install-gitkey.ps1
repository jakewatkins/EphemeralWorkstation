#
# pull the git key from the keyvault
# requires that I be logged in to my tenent
#

mkdir ~/.ssh
az keyvault secret download --name gitKey --vault-name kvGPSecrets --file ~/.ssh/id_rsa
C:\SourceCode\bin\dos2unix c:\users\sysadmin\.ssh\id_rsa



