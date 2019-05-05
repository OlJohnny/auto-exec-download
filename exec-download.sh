#!/bin/bash


### check for root privilges ###
if [ "$EUID" -ne 0 ]
then
  echo -e "\e[91mPlease run as root.\e[39m Root privileges are needed to move and delete files"
  exit
fi


### cleanup ===
rm -f ./{*.exe,*.msi}


### winrar ###
echo "<$(date +"%T")> Getting WinRar..."
wget -qO- https://www.winrar.de/downld.php | grep -Eoi '<a.+href="[^\"]+"' | grep -Eo '(http|https):\/\/winrar.*x64-[0-9]{3}d\.exe' | xargs wget -q


### cpu-z ###
echo "<$(date +"%T")> Getting CPU-Z..."
wget -qO- https://www.cpuid.com/softwares/cpu-z.html | grep -Eoi '<a.+href="[^\"]+"' | grep -Eo '/downloads/cpu-z/cpu-z_[0-9]{1}\.[0-9]{2}-en\.exe' | head -n1 > ./.exec-work
sed -i '1 i\https://www.cpuid.com' ./.exec-work
sed -i ':a;N;$!ba;s/\n//g' ./.exec-work
wget -qO- -i ./.exec-work | grep -Eoi '<a.+href="[^\"]+"' | grep -Eo '(http|https)://download\.cpuid\.com/cpu-z/cpu-z_[0-9]\.[0-9]{2}-en\.exe' | xargs wget -q
rm ./.exec-work


### hwmonitor ###
echo "<$(date +"%T")> Getting HWMonitor..."
wget -qO- https://www.cpuid.com/softwares/hwmonitor.html | grep -Eoi '<a.+href="[^\"]+"' | grep -Eo '/downloads/hwmonitor/hwmonitor_[0-9]{1}\.[0-9]{2}\.exe' | head -n1 > ./.exec-work
sed -i '1 i\https://www.cpuid.com' ./.exec-work
sed -i ':a;N;$!ba;s/\n//g' ./.exec-work
wget -qO- -i ./.exec-work | grep -Eoi '<a.+href="[^\"]+"' | grep -Eo '(http|https)://download\.cpuid\.com/hwmonitor/hwmonitor_[0-9]\.[0-9]{2}\.exe' | xargs wget -q
rm ./.exec-work


### geforce experience ###
echo "<$(date +"%T")> Getting GeForce Experience..."
wget -qO- https://www.nvidia.de/object/geforce-experience-download-de.html | grep -Eoi '<a.+href="[^\"]+"' | grep -Eo '//de\.download\.nvidia\.com/GFE/GFEClient/.*\.exe' > ./.exec-work
sed -i '1 i\https:' ./.exec-work
sed -i ':a;N;$!ba;s/\n//g' ./.exec-work
wget -qi ./.exec-work
rm ./.exec-work


### putty ###
echo "<$(date +"%T")> Getting PuTTY..."
wget -qO- https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html | grep -Eoi '<a.+href="[^\"]+"' | grep -Eo 'https://the\.earth\.li/~sgtatham/putty/latest/w64/putty-64bit-[0-9]\.[0-9]{2}-installer\.msi' | head -n1 | xargs wget -q


### vlc ###
echo "<$(date +"%T")> Getting VLC..."
wget -qO- https://www.vlc.de/vlc_download_64bit.php | grep -Eoi '<a.+href="[^\"]+"' | grep -Eo '//files\.vlc\.de/vlc/vlc-[0-9]\.[0-9]\.[0-9]-win64\.exe' > ./.exec-work
sed -i '1 i\https:' ./.exec-work
sed -i ':a;N;$!ba;s/\n//g' ./.exec-work
wget -qi ./.exec-work
rm ./.exec-work


### mp3tag ###
echo "<$(date +"%T")> Getting MP3Tag..."
wget -qO- https://www.mp3tag.de/dodownload.html | sed -e ':a;N;$!ba;s/\s\{2\}\n//g' | grep -Eoi '<a.+href="[^\"]+"' | grep -Eo 'https://download\.mp3tag\.de/mp3tagv[0-9]{3}setup\.exe' | xargs wget -q


### java ###
echo "<$(date +"%T")> Getting Java (JRE)..."
wget -qO- https://java.com/de/download/manual.jsp | grep -Eoi '<a title="Download der Java-Software für Windows \(64-Bit\)" href="[^\"]+"' | grep -Eo 'https://javadl\.oracle\.com/webapps/download/AutoDL\?BundleId=[0-9]{6}_([0-9]|[a-z]){32}' | head -n1 | xargs wget -q
echo "JRE " > ./.exec-work
wget -qO- https://java.com/de/download/manual.jsp | grep -Eoi 'Version [0-9] Update [0-9]{3}' >> ./.exec-work
echo ".exe" >> ./.exec-work
sed -i ':a;N;$!ba;s/\n//g' ./.exec-work
cat ./.exec-work | xargs -I {} mv AutoDL\?BundleId\=* {}
rm ./.exec-work


### notepad++ ###
echo "<$(date +"%T")> Getting Notepad++..."
wget -qO- https://notepad-plus-plus.org/download | grep -Eoi '<a.+href="[^\"]+"' | grep -Eo '/repository/[0-9]\.x/[0-9]\.[0-9]\.[0-9]/npp\.[0-9]\.[0-9]\.[0-9]\.Installer\.x64\.exe' | head -n1 > ./.exec-work
sed -i '1 i\https://notepad-plus-plus.org' ./.exec-work
sed -i ':a;N;$!ba;s/\n//g' ./.exec-work
wget -qi ./.exec-work
rm ./.exec-work


### balena etcher ###
echo "<$(date +"%T")> Getting Balena Etcher..."
wget -qO- https://www.balena.io/etcher/ | grep -Eoi '<a.+href="[^\"]+"' | grep -Eo 'https://github\.com/balena-io/etcher/releases/download/v[0-9]\.[0-9]\.[0-9]{2}/balenaEtcher-Setup-[0-9]\.[0-9]\.[0-9]{2}-x64\.exe' | xargs wget -q


### teamspeak client ###
echo "<$(date +"%T")> Getting Teamspeak Client..."
wget -qO- https://www.teamspeak.de/download/teamspeak-3-64-Bit-client-windows/ | grep -Eoi '<a.+href="[^\"]+"' | grep -Eo 'http://dl\.4players\.de/ts/releases/[0-9]\.[0-9]\.[0-9]/TeamSpeak3-Client-win64-[0-9]\.[0-9]\.[0-9]\.exe' | xargs wget -q


### filezilla ###
echo "<$(date +"%T")> Getting FileZilla..."
wget -qO- -U "Mozilla/5.0 (Windows NT 10.0; Win64; x64)" https://filezilla-project.org/download.php?type=client | grep -Eoi '<a.+href="[^\"]+"' | grep -Eo 'https://download\.filezilla-project\.org/client/FileZilla_[0-9]\.[0-9]{2}\.[0-9]_win64_sponsored-setup\.exe' | head -n1 | xargs wget -q



### TODO ###
# CrystalDiskInfo/Mark
# OBS Studio
# GPU-Z
# WinDirStat
# KeePass (Difficulties with Sourceforge)


### move to destination ###
now=$(date +"%T")
echo "<$now> Moving to destination..."
rm /active_pool/programs/auto-download/{*.exe,*.msi}   # You will need to edit this path
mv ./{*.exe,*.msi} /active_pool/programs/auto-download/    # You will need to edit this path
chmod +x /active_pool/programs/auto-download/{*.exe,*.msi} # You will need to edit this path