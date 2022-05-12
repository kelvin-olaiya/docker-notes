sudo apt update

sudo apt -y install apt-transport-https ca-certificates curl software-propertites-common

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"

sudo apt update

apt-cache policy docker-ce

sudo apt install -y docker-ce docker-ce-cli containered.io

sudo systemctl status docker