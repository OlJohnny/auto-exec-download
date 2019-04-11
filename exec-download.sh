#!/bin/bash


### check for root privilges ###
if [ "$EUID" -ne 0 ]
then
  echo -e "\e[91mPlease run as root.\e[39m Root privileges are needed to move and delete files"
  exit
fi


### cleanup ===
rm -rf ./*.exe


### winrar ###
now=$(date +"%T")
echo "<$now> Getting WinRar..."
wget -qO- https://www.winrar.de/downld.php | grep -Eoi '<a [^>]+>' | grep -Eo 'href="[^\"]+"' | grep -Eo '(http|https):\/\/winrar.*x64-[0-9]{3}d\.exe' | xargs wget -q


### cpu-z ###
now=$(date +"%T")
echo "<$now> Getting CPU-Z..."
wget -qO- https://www.cpuid.com/softwares/cpu-z.html | grep -Eoi '<a [^>]+>' | grep -Eo 'href="[^\"]+"' | grep -Eo '/downloads/cpu-z/cpu-z_[0-9]{1}\.[0-9]{2}-en\.exe' | head -n1 > ./.exec-work
sed -i '1 i\https://www.cpuid.com' ./.exec-work
sed -i ':a;N;$!ba;s/\n/,/g' ./.exec-work
sed -i 's/,//g' ./.exec-work
cat ./.exec-work | xargs wget -qO- | grep -Eoi '<a [^>]+>' | grep -Eo 'href="[^\"]+"' | grep -Eo '(http|https)://download\.cpuid\.com/cpu-z/cpu-z_[0-9]\.[0-9]{2}-en\.exe' | xargs wget -q
rm ./.exec-work


### hwmonitor ###
now=$(date +"%T")
echo "<$now> Getting HWMonitor..."
wget -qO- https://www.cpuid.com/softwares/hwmonitor.html | grep -Eoi '<a [^>]+>' | grep -Eo 'href="[^\"]+"' | grep -Eo '/downloads/hwmonitor/hwmonitor_[0-9]{1}\.[0-9]{2}\.exe' | head -n1 > ./.exec-work
sed -i '1 i\https://www.cpuid.com' ./.exec-work
sed -i ':a;N;$!ba;s/\n/,/g' ./.exec-work
sed -i 's/,//g' ./.exec-work
cat ./.exec-work | xargs wget -qO- | grep -Eoi '<a [^>]+>' | grep -Eo 'href="[^\"]+"' | grep -Eo '(http|https)://download\.cpuid\.com/hwmonitor/hwmonitor_[0-9]\.[0-9]{2}\.exe' | xargs wget -q
rm ./.exec-work


### TODO ###
# Teamspeak 3 Client
# Putty
# FileZilla
# CrystalDiskInfo/Mark
# Google Chrome
# MP3Tag
# Notepad++
# OBS Studio
# GPU-Z
# VLC
# WinDirStat


### move to destination ###
now=$(date +"%T")
echo "<$now> Copying to destination..."
sudo rm /active_pool/programs/auto-download/*.exe	 # You will need to edit this path
sudo cp ./*.exe /active_pool/programs/auto-download/ # You will need to edit this path