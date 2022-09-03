#
# pull the git key from the keyvault
# requires that I be logged in to my tenent
#

mkdir ~/.ssh
#az keyvault secret download --name gitKey --vault-name kvGPSecrets --file ~/.ssh/id_rsa
az keyvault secret show --vault-name kvGPSecrets --name gitKey | jq -r .value > ~/.ssh/id_rsa
