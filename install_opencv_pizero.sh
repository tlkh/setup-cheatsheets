#!/bin/bash  
echo "Installing OpenCV 3.4.0. This will take a while."  
echo "Installing supporting packages."
echo "Updating repositories first"  
sudo apt update
echo "Done. Proceeding with install." 
sudo apt-get install build-essential cmake pkg-config -y
sudo apt-get install libjpeg-dev libtiff5-dev libjasper-dev libpng12-dev -y
sudo apt-get install libavcodec-dev libavformat-dev libswscale-dev libv4l-dev -y
sudo apt-get install libxvidcore-dev libx264-dev -y
sudo apt-get install libgtk2.0-dev -y
sudo apt-get install libatlas-base-dev gfortran -y
sudo apt-get install python-dev python3-dev python-pip python3-pip -y
sudo apt clean -y
echo "Done."
cd ~
echo "Downloading OpenCV 3.4.0 sources (including opencv_contrib)."
wget -O opencv.zip https://github.com/opencv/opencv/archive/3.4.0.zip
wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/3.4.0.zip
echo "Extracting archives."
unzip opencv.zip
unzip opencv_contrib.zip
echo "Installing numpy"
sudo apt install python3-numpy -y
echo "Deleting pip cache"
sudo rm -rf ~/.cache/pip
echo "Preparing to build OpenCV"
cd ~/opencv-3.4.0/
mkdir build
cd build
echo "Not building examples and tests"
echo "Including contrib modules"
#echo "Including NEON and VFPV3 optimisations (RPi 3)"
sudo make clean
cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib-3.4.0/modules \
    -D BUILD_TESTS=OFF \
    -D INSTALL_PYTHON_EXAMPLES=OFF \
    -D BUILD_EXAMPLES=OFF ..
echo "Now compiling OpenCV..."
echo "This will take QUITE A WHILE!!"
echo "(single core build - recommended for RPi 0)"
make # -j4 (quad core build)
echo "Congratulations, it is done. Installing now."
sudo make install
sudo ldconfig
cd ~
echo "Goodbye!"
