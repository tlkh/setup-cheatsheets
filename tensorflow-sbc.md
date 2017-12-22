TensorFlow is an open source machine intelligence library by Google. Edges devices are devices that are deployed at the end of the IoT chain, such as smart sensors and displays. The more capable edges devices usually take the form of single board computers, or SBCs. This guide provides the instructions on how to compile and install Tensorflow from sources on a generic ARM SBC such as the Odroid XU4 (ARM v7l / Kernel 4.9).

I will be using the Odroid XU4 here. This guide will also work for the Raspberry Pi and many other ARM boards. This is a very long process, so be ready!

In order to install TensorFlow, you would need around 2GB of free space on your device and good internet access during the installation process. TensorFlow will function offline after that. You will also need a USB flash drive to provide additional swap space for your device in order to successfully compile TensorFlow.
(You really need an external USB flash drive! The compile will not succeed even if you have an additional swap partition on your eMMC. For best performance, use a USB3.0 flash drive with good write speeds.)

First, we go through the usual dance to ensure everything on the board is up to date to begin with:
sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get dist-upgrade -y && sudo reboot

Installing dependences
For the C++ compiler:

1
2
3
4
sudo apt-get install pkg-config zip g++ zlib1g-dev unzip
sudo apt-get install gcc-4.8 g++-4.8
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 100
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.8 100
For Python 2.7:

1
2
sudo apt-get install python-pip python-numpy swig python-dev
sudo pip install wheel
For Python 3.5:

1
2
sudo apt-get install python3-pip python3-numpy swig python3-dev
sudo pip3 install wheel
Create your working directory:

1
2
mkdir tensorflow
cd tensorflow
Making swap
Next, we will prepare the USB flash drive to use as swap. Make sure you don’t have any important data you can’t afford to lose on the drive as we will be formatting it to use as swap. Plug in your flash drive into the USB3.0 port now.

In Linux, external devices are mounted in the /dev/ directory. We will need to find out where our flash drive is mounted.

1
sudo blkid
In a typical Ubuntu installation, it should be mounted at /dev/sda1 but never assume!
Also, do take not of the UUID associated with your device. Take a photo or copy it to another text file for safekeeping. You’ll be needing it later.

1
2
3
sudo umount /dev/XXX
sudo mkswap /dev/XXX
sudo nano /etc/fstab
Now, we have to add this line of code to the end of the fstab file.

1
UUID=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX none swap sw,pri=5 0 0
Press Ctrl-X to save the file and exit nano.

1
sudo swapon -a
And you are done! Your device should now have 4GB or more swap space available for it.

Building Bazel
Next, we are going to build and install Bazel. The latest stable Bazel release is 0.5.4 (as of 13 September 2017). You can find out more about Bazel here. Do check if there is a later release of Bazel.

1
2
3
4
wget https://github.com/bazelbuild/bazel/releases/download/0.5.4/bazel-0.5.4-dist.zip
unzip -d bazel bazel-0.5.4-dist.zip
cd bazel
sudo ./compile.sh
Do note that the above process will take quite some time depending on your device! It’s time to go grab a snack.

After that’s done, we can now copy the compiled binary to somewhere a little more useful.

1
sudo cp output/bazel /usr/local/bin/bazel
To make sure it’s working properly, run bazel in new Terminal window and verify it prints the help text. This may take 15-30 seconds to run as it has to uncompress the binary, so be patient! The good news is this usually only happens on the first run, or after the cache is cleared.

1
cd ..
The actual work (Compiling TensorFlow)
Now, we can finally more on to actually compiling TensorFlow.

1
2
3
git clone --recurse-submodules https://github.com/tensorflow/tensorflow.git
cd tensorflow
./configure
1
2
3
4
5
6
In the configuration wizard that appears, specify the python binary that would like TensorFlow to use. In all other options, just go with the default unless you want something specific.
Please specify the location of python. [Default is /usr/bin/python]:
Please specify optimization flags to use during compilation when bazel option "--config=opt" is specified [Default is -march=native]:
Do you wish to use jemalloc as the malloc implementation? [Y/n] Y
Please input the desired Python library path to use. Default is [/usr/local/lib/python2.7/dist-packages]:
...
Note: if you want to build for Python 3, specify /usr/bin/python3 for Python’s location and /usr/local/lib/python3.5/dist-packages for the Python library path. This often depends on which particular APIs or models you want to use in TensorFlow as some are not compatible with Python or Python 3.

Now, you are ready for the big (slightly less than 3 hours on my Odroid XU4) build! Proper cooling will help a lot (for Raspberry Pi 3 as well) to avoid thermal throttling.

We will have to build this in two attempts. We will speed through the first attempt by setting our resource settings to maximum.

1
bazel build -c opt --copt="-mfpu=neon-vfpv4" --copt="-funsafe-math-optimizations" --copt="-ftree-vectorize" --copt="-fomit-frame-pointer" --local_resources 8192,8.0,1.0 --verbose_failures tensorflow/tools/pip_package:build_pip_package
Important parameter: –local_resources (RAM),(cores),(IO?) You should allocate less than RAM then the combined total of your onboard SDRAM and the swap space. More than 4096MB of RAM is ideal.

This compile will fail in two ways:

Unable to download a certain package
Unable to finish compiling the Eigen module
If you reach the second part, then feel free to skip the following section and proceed to the one that guides you through how to fix the Eigen module. Otherwise, here’s how to resolve package downloading issues:

(actually I forgot. I’ll come back to this.)

The general idea is to download the problematic packages individually and then reference them in the install script. It would be somewhat more efficient if the packages were downloaded on an external drive (the microSD card slot on the Odroid XU4 comes in useful here) as it will increase the I/O in the eMMC available to the compiler as it can read from an external source and then extract/compile onto the eMMC.

The Eigen module can be found in ~/.cache/bazel/(session_code)/external/eigen_archive/Eigen. Replace some specific files in this folder (not the entire folder!) with the ones that can be downloaded from here.

Run the compiler again, and it should succeed. This will take hours!

1
bazel build -c opt --copt="-mfpu=neon-vfpv4" --copt="-funsafe-math-optimizations" --copt="-ftree-vectorize" --copt="-fomit-frame-pointer" --local_resources 8196,4.0,1.0 --verbose_failures tensorflow/tools/pip_package:build_pip_package
Notice that this time, I only use 4 cores. This is because in the compilation process, the actual 2GB of SDRAM on the Odroid XU4 does fill up fairly often, leading to the compiler having to shift some memory work onto the swap, which is much, much slower. Having less threads running means that this happens less often, and overall resulting in a faster compile time.

On the Raspberry Pi, it may be more stable to use only 1 or 2 cores as somehow the Raspberry Pi seems more prone to race conditions. You’ll likely be compiling overnight anyway.

Congratulations, you are done!
It’s time to copy out the completed installation package:

1
2
bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg
ls /tmp/tensorflow_pkg
Take note of your package name.

Run the install! Go on, you’ve earned it:

1
sudo pip install /tmp/tensorflow_pkg/
Cleanup:

1
2
sudo swapoff /dev/XXX
sudo nano /etc/fstab
Remove the line that you added before (way up there)

1
sudo reboot
You’re done!

The instructions here are accurate as of 7 October 2017. Since then, new versions of the packages may have been released.