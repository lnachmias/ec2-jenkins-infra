#!/bin/bash

echo "Updating Ubuntu"
sudo su
apt update -y

echo "Installing Java for Jenkins"
apt install default-jre default-jdk -y
java -version
javac -version

echo "Installing some initial dependencies and docker"
apt install git wget unzip curl docker.io -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
snap install dockerapt
docker --version

echo "Installing Terraform"
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
apt install terraform
terraform -v

echo "Installing Jenkins"
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update
sudo apt install jenkins -y

echo "Setting Jenkins User on Sudoers"
sudo su
echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

echo "Starting up Jenkins"
sudo systemctl start jenkins
sudo systemctl enable jenkins
systemctl status jenkins
sudo ufw allow 8080
sudo ufw allow OpenSSH
sudo ufw enable
sudo ufw status


echo "Installation is done, use this password for the initial login:"
cat /var/lib/jenkins/secrets/initialAdminPassword

