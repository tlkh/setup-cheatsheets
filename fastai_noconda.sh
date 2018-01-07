#!/bin/bash
echo 'Script for setting up fast.ai enviroment WITHOUT Anaconda or virtual environments'
cd ~
echo 'Updating repository...'
sudo apt update
echo 'Upgrading packages...'
sudo apt update -y --force-yes && sudo apt dist-update -y --force-yes
echo 'Cleaning up...'
sudo apt autoremove -y && sudo apt clean
echo 'Done! Moving on with install.'

echo 'Installing Python (system default, probably 3.5) ...'
sudo apt install python3-dev python3-pip python-dev python-pip -y
echo 'Installing Python 3.6 from jonathonf/python-3.6'
sudo add-apt-repository ppa:jonathonf/python-3.6
sudo apt update
sudo apt install python3.6 python3.6-dev -y
echo 'Setting up pip3.6'
curl https://bootstrap.pypa.io/get-pip.py | sudo python3.6
echo 'Now installing Python 3.6 libraries:'
echo '(1/3) - tqdm graphviz numpy scipy matplotlib jupyter ipywidgets pillow'
sudo pip3.6 install tqdm graphviz numpy scipy matplotlib jupyter ipywidgets pillow
echo '(2/3) - bcolz seaborn isoweek pandas sklearn'
sudo pip3.6 install bcolz seaborn isoweek pandas sklearn
echo '(3/3) - pandas_summary opencv-contrib-python sklearn_pandas'
sudo pip3.6 install pandas_summary opencv-contrib-python sklearn_pandas
echo '... enabling widgets for Jupyter'
jupyter nbextension enable --py widgetsnbextension --sys-prefix
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
cd ~/downloads/
echo '(1/3 - Downloading CUDA 9.0)'
wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_9.0.176-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1604_9.0.176-1_amd64.deb
sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub
sudo apt update
sudo apt install cuda -y
echo '(2/3 - Downloading cuDNN 9.1)'
wget http://files.fast.ai/files/cudnn-9.1-linux-x64-v7.tgz
tar xf cudnn-9.1-linux-x64-v7.tgz
echo '(3/3 - Moving files to proper paths)'
sudo cp cuda/include/*.* /usr/local/cuda/include/
sudo cp cuda/lib64/*.* /usr/local/cuda/lib64/
echo "Shower thought: Wouldn't it be nice to have an alternative to CUDA?"
echo 'Done installing GPU drivers'

echo 'Installing PyTorch linux/p3.6/CUDA8...'
sudo pip3.6 install http://download.pytorch.org/whl/cu90/torch-0.3.0.post4-cp36-cp36m-linux_x86_64.whl 
pip3 install torchvision

echo 'Installing Python 3.6 as default Python 3 kernel for Jupyter Notebook.'
python3.6 -m ipykernel install —user

cd ~

echo 'Downloading data files.'

echo '(1/2) - Cloning main fastai repository from GitHub...'
git clone https://github.com/fastai/fastai.git

mkdir data
cd data
echo '(2/2) - Downloading dogscats dataset...'
wget http://files.fast.ai/data/dogscats.zip
sudo apt install unzip -y
unzip -q dogscats.zip
echo 'Linking directories.'
cd ../fastai/courses/dl1/
ln -s ~/data ./
echo 'Done!'

echo 'Instance will now reboot. SSH session will disconnect.'
sudo reboot
