#!/bin/sh

echo "Installation script for Docker CE and nvidia-docker on Ubuntu 16+"

echo "Set non-interactive frontend"
echo "Script will run without any prompts"
DEBIAN_FRONTEND=noninteractive

echo "Installing prerequisites for Docker CE"

apt-get update
apt-get remove docker docker-engine docker.io -y
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

apt-key fingerprint 0EBFCD88

 sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

echo "Installing Docker CE"

apt-get update
apt-get install docker-ce -y

echo "Testing Docker CE with hello-world container"

docker run --rm hello-world

echo "Installing nvidia-docker"

curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | apt-key add -

distribution=$(. /etc/os-release;echo $ID$VERSION_ID)

curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | tee /etc/apt/sources.list.d/nvidia-docker.list

apt-get update
apt-get install nvidia-docker2

echo "Installed nvidia-docker"
echo "Restart Docker daemon"

echo "Finished with no errors."