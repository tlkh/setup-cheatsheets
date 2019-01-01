#!/bin/sh

echo "Installation script for Docker CE and nvidia-docker on Ubuntu 16+"

echo "Set non-interactive frontend"
echo "Script will run without any prompts"
DEBIAN_FRONTEND=noninteractive

echo "\n###\n"
echo "Installing prerequisites for Docker CE"
echo "\n###\n"

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

echo "\n###\n"
echo "Installing Docker CE"
echo "\n###\n"

apt-get update
apt-get install docker-ce -y

echo "\n###\n"
echo "Testing Docker CE with hello-world container"
echo "\n###\n"

docker run --rm hello-world

echo "\n###\n"
echo "Installing nvidia-docker"
echo "\n###\n"

curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | apt-key add -

distribution=$(. /etc/os-release;echo $ID$VERSION_ID)

curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | tee /etc/apt/sources.list.d/nvidia-docker.list

apt-get update
apt-get install nvidia-docker2 -y

echo "Installed nvidia-docker"
echo "Restarting Docker daemon"

pkill -SIGHUP dockerd

echo "\n###\n"
echo "Testing nvidia-docker"
echo "\n###\n"

docker run --runtime=nvidia --rm nvidia/cuda:9.0-runtime-ubuntu16.04 nvidia-smi

echo "\n###\n"
echo "Finished with no errors."
