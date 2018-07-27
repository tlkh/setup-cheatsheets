#!/bin/bash
echo 'Updating repository...'
sudo apt update
echo 'Upgrading packages...'
sudo apt upgrade -y && sudo apt dist-upgrade -y
echo 'Cleaning up...'
sudo apt autoremove -y && sudo apt clean
echo 'Done! Moving on with install.'

echo 'Installing Python (system default, probably 3.5) ...'
sudo apt install git python3-dev python3-pip python-dev python-pip -y

echo 'Now installing Python 3 libraries:'
sudo pip3 install setuptools pip wheel --upgrade
sudo pip3 install numpy scipy matplotlib jupyter ipywidgets pillow
sudo pip3 install bcolz seaborn pandas sklearn keras tensorflow
sudo pip3 install opencv-contrib-python
sudo rm -R ~/.jupyter
echo '... enabling widgets for Jupyter'
sudo jupyter nbextension enable --py widgetsnbextension --sys-prefix
echo '... generating config'
jupyter notebook --generate-config
echo 'Jupyter Notebook will be made accessible from:'
sudo ifconfig | grep inet
echo "c.NotebookApp.ip = '*'" >> ~/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.open_browser = False" >> ~/.jupyter/jupyter_notebook_config.py
echo 'Done!'

echo 'Configuring firewall (ufw) to allow ports 8888 and 8889'
sudo ufw allow 8888
sudo ufw allow 8889

echo 'Installing GPU drivers'
echo 'All hail the Nvidia gods'
sudo apt -y install qtdeclarative5-dev qml-module-qtquick-controls
sudo add-apt-repository ppa:graphics-drivers/ppa -y
sudo apt update
mkdir ~/downloads/
cd ~/downloads/
sudo rm *
echo '(1/3 - Downloading CUDA 9.2)'
wget https://developer.nvidia.com/compute/cuda/9.2/Prod/local_installers/cuda-repo-ubuntu1604-9-2-local_9.2.88-1_amd64
sudo dpkg -i cuda-repo-ubuntu1604-9-2-local_9.2.88-1_amd64
sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub
sudo apt update
sudo apt install cuda -y
echo '(2/3 - Downloading cuDNN 7.0)'
wget https://tlkh.design/downloads/cudnn-9.2-linux.tgz
tar xf cudnn-9.2-linux.tgz
echo '(3/3 - Moving files to proper paths)'
sudo cp cuda/include/*.* /usr/local/cuda/include/
sudo cp cuda/lib64/*.* /usr/local/cuda/lib64/
echo "Shower thought: Wouldn't it be nice to have an alternative to CUDA?"
echo 'Done installing GPU drivers'

echo 'Instance will now reboot. SSH session will disconnect.'
sudo reboot
