This page is a collection of useful commands and scripts for Linux that I’ve compiled over my various projects. I decided to keep this list mostly to solve common annoyances with stuff that should work, but doesn’t really work as it should. Most people will find use for these scripts while deploying their projects on single board computers such as the Raspberry Pi, Odroid XU4 or Beaglebone Black.

To make a script run on startup, edit the rc.local file and check is it is running

1
2
sudo nano /etc/rc.local
systemctl status rc-local.service.
Check IP address with sudo ifconfig and see eth0 or wlan0 etc.

Automatically set the date/time:

1
sudo date -s "$(wget -qSO- --max-redirect=0 google.com 2&gt;&amp;1 | grep Date: | cut -d' ' -f5-8)Z"
Update and reboot:

1
sudo apt-get update &amp;&amp; sudo apt-get upgrade -y &amp;&amp; sudo reboot
SSH Remote Access:

1
2
sudo systemctl enable ssh
sudo systemctl restart sshd.service
Configuring VNC (Ubuntu MATE):

1
2
3
4
5
sudo apt-get install vncserver
vncserver
sudo nano .vnc/xstartup
nano .vnc/xstartup
chmod 777 .vnc/xstartup
Insert the following lines:

1
2
3
4
5
6
7
8
9
#!/bin/sh
/usr/bin/mate-session
xrdb $HOME/.Xresources
xsetroot -solid grey
#x-terminal-emulator -geometry 80x24+10+10 -ls -title "$VNCDESKTOP Desktop" &amp;amp;
x-window-manager &amp;amp;
# Fix to make GNOME work
export XKL_XMODMAP_DISABLE=1
#/etc/X11/Xsession
To make VNC start automatically:

1
su - pi -c '/usr/bin/tightvncserver'
(where pi is the username)

Uninstall bloat (Ubuntu MATE):

1
sudo apt-get purge scratch minecraft-pi shotwell firefox hexchat pidgin thunderbird atril fluid sonic-pi brasero cheese rhythmbox libreoffice-writer libreoffice-impress libreoffice-calc libreoffice-draw simple-scan synapse
My script to install OpenCV 3.3.0 for modern ARM boards.
View and download it from GitHub.

Useful External Links:

Useful Terminal Commands
OpenCV Install
ROS Install (get Ubuntu MATE here)
RPi-Cam-Web-Interface – eLinux.org (live stream with web interface)
WebIOPi (run any python script over web interface) (use this install method to get it working)
