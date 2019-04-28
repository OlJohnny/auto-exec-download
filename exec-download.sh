#!/bin/bash


### check for root privilges ###
if [ "$EUID" -ne 0 ]
then
  echo -e "\e[91mPlease run as root.\e[39m Root privileges are needed to move and delete files"
  exit
fi


### cleanup ===
rm -f ./*.exe


### winrar ###
now=$(date +"%T")
echo "<$now> Getting WinRar..."
wget -qO- https://www.winrar.de/downld.php | grep -Eoi '<a.+href="[^\"]+"' | grep -Eo '(http|https):\/\/winrar.*x64-[0-9]{3}d\.exe' | xargs wget -q


### cpu-z ###
now=$(date +"%T")
echo "<$now> Getting CPU-Z..."
wget -qO- https://www.cpuid.com/softwares/cpu-z.html | grep -Eoi '<a.+href="[^\"]+"' | grep -Eo '/downloads/cpu-z/cpu-z_[0-9]{1}\.[0-9]{2}-en\.exe' | head -n1 > ./.exec-work
sed -i '1 i\https://www.cpuid.com' ./.exec-work
sed -i ':a;N;$!ba;s/\n/,/g' ./.exec-work
sed -i 's/,//g' ./.exec-work
wget -qO- -i ./.exec-work | grep -Eoi '<a.+href="[^\"]+"' | grep -Eo '(http|https)://download\.cpuid\.com/cpu-z/cpu-z_[0-9]\.[0-9]{2}-en\.exe' | xargs wget -q
rm ./.exec-work


### hwmonitor ###
now=$(date +"%T")
echo "<$now> Getting HWMonitor..."
wget -qO- https://www.cpuid.com/softwares/hwmonitor.html | grep -Eoi '<a.+href="[^\"]+"' | grep -Eo '/downloads/hwmonitor/hwmonitor_[0-9]{1}\.[0-9]{2}\.exe' | head -n1 > ./.exec-work
sed -i '1 i\https://www.cpuid.com' ./.exec-work
sed -i ':a;N;$!ba;s/\n/,/g' ./.exec-work
sed -i 's/,//g' ./.exec-work
wget -qO- -i ./.exec-work | grep -Eoi '<a.+href="[^\"]+"' | grep -Eo '(http|https)://download\.cpuid\.com/hwmonitor/hwmonitor_[0-9]\.[0-9]{2}\.exe' | xargs wget -q
rm ./.exec-work


### geforce experience ###
now=$(date +"%T")
echo "<$now> Getting GeForce Experience..."
wget -qO- https://www.nvidia.de/object/geforce-experience-download-de.html | grep -Eoi '<a.+href="[^\"]+"' | grep -Eo '//de\.download\.nvidia\.com/GFE/GFEClient/.*\.exe' > ./.exec-work
sed -i '1 i\https:' ./.exec-work
sed -i ':a;N;$!ba;s/\n/,/g' ./.exec-work
sed -i 's/,//g' ./.exec-work
wget -qi ./.exec-work
rm ./.exec-work


### putty ###
now=$(date +"%T")
echo "<$now> Getting PuTTY..."
wget -qO- https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html | grep -Eoi '<a.+href="[^\"]+"' | grep -Eo 'https://the\.earth\.li/~sgtatham/putty/latest/w64/putty-64bit-[0-9]\.[0-9]{2}-installer\.msi' | head -n1 | xargs wget -q


### vlc ###
now=$(date +"%T")
echo "<$now> Getting VLC..."
wget -qO- https://www.vlc.de/vlc_download_64bit.php | grep -Eoi '<a.+href="[^\"]+"' | grep -Eo '//files\.vlc\.de/vlc/vlc-[0-9]\.[0-9]\.[0-9]-win64\.exe' > ./.exec-work
sed -i '1 i\https:' ./.exec-work
sed -i ':a;N;$!ba;s/\n/,/g' ./.exec-work
sed -i 's/,//g' ./.exec-work
wget -qi ./.exec-work
rm ./.exec-work



### TODO ###
# Teamspeak 3 Client
# FileZilla
# CrystalDiskInfo/Mark
# MP3Tag
# Notepad++
# OBS Studio
# GPU-Z
# WinDirStat


### move to destination ###
now=$(date +"%T")
echo "<$now> Copying to destination..."
rm /active_pool/programs/auto-download/*.exe	   # You will need to edit this path
cp ./{*.exe,*.msi} /active_pool/programs/auto-download/    # You will need to edit this path
rm -f ./{*.exe,*.msi}
chmod +x /active_pool/programs/auto-download/{*.exe,*.msi} # You will need to edit this path