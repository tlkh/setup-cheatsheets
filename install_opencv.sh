#!/bin/bash  
echo "Installing OpenCV 3.3.1. This will take a while."  
echo "Installing supporting packages."
echo "Updating repositories first"  
sudo apt-get update
echo "Done. Proceeding with install." 
sudo apt-get install build-essential cmake pkg-config -y
sudo apt-get install libjpeg-dev libtiff5-dev libjasper-dev libpng12-dev -y
sudo apt-get install libavcodec-dev libavformat-dev libswscale-dev libv4l-dev -y
sudo apt-get install libxvidcore-dev libx264-dev -y
sudo apt-get install libgtk2.0-dev -y
sudo apt-get install libatlas-base-dev gfortran -y
sudo apt-get install python2.7-dev python3-dev -y
echo "Done."
cd ~
echo "Downloading OpenCV 3.3.1 sources (including opencv_contrib)."
wget -O opencv.zip https://github.com/Itseez/opencv/archive/3.3.1.zip
wget -O opencv_contrib.zip https://github.com/Itseez/opencv_contrib/archive/3.3.1.zip
echo "Extracting archives."
unzip opencv.zip
unzip opencv_contrib.zip
echo "Installing pip"
wget https://bootstrap.pypa.io/get-pip.py
sudo python get-pip.py
echo "Installing numpy"
pip install numpy
echo "Deleting pip cache"
sudo rm -rf ~/.cache/pip
echo "Preparing to build OpenCV"
cd ~/opencv-3.3.1/
mkdir build
cd build
echo "Not building examples."
cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D INSTALL_PYTHON_EXAMPLES=OFF \
    -D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib-3.3.1/modules \
    -D BUILD_EXAMPLES=OFF ..
echo "Now compiling OpenCV."
echo "This will take QUITE A WHILE!!"
echo "(single core build - recommended for Raspberry Pi.)"
make # -j4 (quad core build)
echo "Congratulations, it is done. Installing now."
sudo make install
sudo ldconfig
cd ~
echo "Removing installation files"
sudo rm -R opencv-3.3.1 opencv_contrib-3.3.1 opencv-3.3.1.zip opencv_contrib-3.3.1.zip get-pip.py
echo "Goodbye!"
