#!/bin/bash

##### FUNCTIONS #####
### install dos2unix function ###
var1func(){
read -p "Do you want to install dos2unix? (Needed to correctly display the log file on windows systems) (y|n): " var1
if [[ $var1 == "y" ]]
then
	echo "Installing dos2unix..."
	apt-get --yes install dos2unix
elif [[ $var1 == "n" ]]
then
	echo "Package is needed to complete the run of this script."
	echo "Exiting..."
	exit
else
	var1func
fi
}



##### PREPARATION #####
### check for root privilges ###
if [ "$EUID" -ne 0 ]
then
  echo -e "\e[91mPlease run as root.\e[39m Root privileges are needed to move and delete files"
  exit
fi


### data warning ###
echo "Please note that this script will approximately download 500 MB from the internet."
echo -n "Continuing in 5 seconds"
for i in 1 1 1 1 1
do
	echo -n "."
	sleep 1s
done
echo ""


### install dos2unix ###
echo "Checking if dos2unix is installed..."

if [ $(dpkg-query -W -f='${Status}' dos2unix 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
	var1func
else
	echo "Package dos2unix is already installed"
fi


### cleanup ###
rm -rf ./tmp-aed
mkdir ./tmp-aed



##### DOWNLOAD OF FILES #####
### winrar ###
echo "<$(date +"%T")> Getting WinRar..."
wget -qO- https://www.winrar.de/downld.php | grep -Eoi '<a.+href="[^\"]+"' | grep -Eo '(http|https):\/\/winrar.*x64-[0-9]{3}d\.exe' | xargs wget -qP ./tmp-aed/


### cpu-z ###
echo "<$(date +"%T")> Getting CPU-Z..."
wget -qO- https://www.cpuid.com/softwares/cpu-z.html | grep -Eoi '<a.+href="[^\"]+"' | grep -Eo '/downloads/cpu-z/cpu-z_[0-9]{1}\.[0-9]{2}-en\.exe' | head -n1 > ./tmp-aed/.exec-work
sed -i '1 i\https://www.cpuid.com' ./tmp-aed/.exec-work
sed -i ':a;N;$!ba;s/\n//g' ./tmp-aed/.exec-work
wget -qO- -i ./tmp-aed/.exec-work | grep -Eoi '<a.+href="[^\"]+"' | grep -Eo '(http|https)://download\.cpuid\.com/cpu-z/cpu-z_[0-9]\.[0-9]{2}-en\.exe' | xargs wget -qP ./tmp-aed/
rm ./tmp-aed/.exec-work


### hwmonitor ###
echo "<$(date +"%T")> Getting HWMonitor..."
wget -qO- https://www.cpuid.com/softwares/hwmonitor.html | grep -Eoi '<a.+href="[^\"]+"' | grep -Eo '/downloads/hwmonitor/hwmonitor_[0-9]{1}\.[0-9]{2}\.exe' | head -n1 > ./tmp-aed/.exec-work
sed -i '1 i\https://www.cpuid.com' ./tmp-aed/.exec-work
sed -i ':a;N;$!ba;s/\n//g' ./tmp-aed/.exec-work
wget -qO- -i ./tmp-aed/.exec-work | grep -Eoi '<a.+href="[^\"]+"' | grep -Eo '(http|https)://download\.cpuid\.com/hwmonitor/hwmonitor_[0-9]\.[0-9]{2}\.exe' | xargs wget -qP ./tmp-aed/
rm ./tmp-aed/.exec-work


### geforce experience ###
echo "<$(date +"%T")> Getting GeForce Experience..."
wget -qO- https://www.nvidia.de/object/geforce-experience-download-de.html | grep -Eoi '<a.+href="[^\"]+"' | grep -Eo '//de\.download\.nvidia\.com/GFE/GFEClient/.*\.exe' > ./tmp-aed/.exec-work
sed -i '1 i\https:' ./tmp-aed/.exec-work
sed -i ':a;N;$!ba;s/\n//g' ./tmp-aed/.exec-work
wget -qi ./tmp-aed/.exec-work -P ./tmp-aed/
rm ./tmp-aed/.exec-work


### putty ###
echo "<$(date +"%T")> Getting PuTTY..."
wget -qO- https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html | grep -Eoi '<a.+href="[^\"]+"' | grep -Eo 'https://the\.earth\.li/~sgtatham/putty/latest/w64/putty-64bit-[0-9]\.[0-9]{2}-installer\.msi' | head -n1 | xargs wget -qP ./tmp-aed/


### vlc ###
echo "<$(date +"%T")> Getting VLC..."
wget -qO- https://www.vlc.de/vlc_download_64bit.php | grep -Eoi '<a.+href="[^\"]+"' | grep -Eo '//files\.vlc\.de/vlc/vlc-[0-9]\.[0-9]\.[0-9]-win64\.exe' > ./tmp-aed/.exec-work
sed -i '1 i\https:' ./tmp-aed/.exec-work
sed -i ':a;N;$!ba;s/\n//g' ./tmp-aed/.exec-work
wget -qi ./tmp-aed/.exec-work -P ./tmp-aed/
rm ./tmp-aed/.exec-work


### mp3tag ###
echo "<$(date +"%T")> Getting MP3Tag..."
wget -qO- https://www.mp3tag.de/dodownload.html | sed -e ':a;N;$!ba;s/\s\{2\}\n//g' | grep -Eoi '<a.+href="[^\"]+"' | grep -Eo 'https://download\.mp3tag\.de/mp3tagv[0-9]{3}setup\.exe' | xargs wget -qP ./tmp-aed/


### java ###
echo "<$(date +"%T")> Getting Java (JRE)..."
wget -qO- https://java.com/de/download/manual.jsp | grep -Eoi '<a title="Download der Java-Software für Windows \(64-Bit\)" href="[^\"]+"' | grep -Eo 'https://javadl\.oracle\.com/webapps/download/AutoDL\?BundleId=[0-9]{6}_([0-9]|[a-z]){32}' | head -n1 | xargs wget -qP ./tmp-aed/
echo "./tmp-aed/JRE " > ./tmp-aed/.exec-work
wget -qO- https://java.com/de/download/manual.jsp | grep -Eoi 'Version [0-9] Update [0-9]{3}' >> ./tmp-aed/.exec-work
echo ".exe" >> ./tmp-aed/.exec-work
sed -i ':a;N;$!ba;s/\n//g' ./tmp-aed/.exec-work
cat ./tmp-aed/.exec-work | xargs -I {} mv ./tmp-aed/AutoDL\?BundleId\=* {}
rm ./tmp-aed/.exec-work


### notepad++ ###
echo "<$(date +"%T")> Getting Notepad++..."
wget -qO- https://notepad-plus-plus.org/download | grep -Eoi '<a.+href="[^\"]+"' | grep -Eo '/repository/[0-9]\.x/[0-9]\.[0-9]\.[0-9]/npp\.[0-9]\.[0-9]\.[0-9]\.Installer\.x64\.exe' | head -n1 > ./tmp-aed/.exec-work
sed -i '1 i\https://notepad-plus-plus.org' ./tmp-aed/.exec-work
sed -i ':a;N;$!ba;s/\n//g' ./tmp-aed/.exec-work
wget -qi ./tmp-aed/.exec-work -P ./tmp-aed/
rm ./tmp-aed/.exec-work


### balena etcher ###
echo "<$(date +"%T")> Getting Balena Etcher..."
wget -qO- https://www.balena.io/etcher/ | grep -Eoi '<a.+href="[^\"]+"' | grep -Eo 'https://github\.com/balena-io/etcher/releases/download/v[0-9]\.[0-9]\.[0-9]{2}/balenaEtcher-Setup-[0-9]\.[0-9]\.[0-9]{2}-x64\.exe' | xargs wget -qP ./tmp-aed/


### teamspeak client ###
echo "<$(date +"%T")> Getting Teamspeak Client..."
wget -qO- https://www.teamspeak.de/download/teamspeak-3-64-Bit-client-windows/ | grep -Eoi '<a.+href="[^\"]+"' | grep -Eo 'http://dl\.4players\.de/ts/releases/[0-9]\.[0-9]\.[0-9]/TeamSpeak3-Client-win64-[0-9]\.[0-9]\.[0-9]\.exe' | xargs wget -qP ./tmp-aed/


### filezilla ###
echo "<$(date +"%T")> Getting FileZilla..."
wget -qO- -U "Mozilla/5.0 (Windows NT 10.0; Win64; x64)" https://filezilla-project.org/download.php?type=client | grep -Eoi '<a.+href="[^\"]+"' | grep -Eo 'https://download\.filezilla-project\.org/client/FileZilla_[0-9]\.[0-9]{2}\.[0-9]_win64_sponsored-setup\.exe' | head -n1 | xargs wget -qP ./tmp-aed/



### TODO ###
# CrystalDiskInfo/Mark
# OBS Studio
# GPU-Z
# WinDirStat
# KeePass (Difficulties with Sourceforge)



##### FINISHING #####
### making log ###
echo "Successfully downloaded $(find ./tmp-aed/*.{exe,msi} | wc -l)/12 programms:" | tee ./tmp-aed/aed-$(date +%Y.%m.%d-%H-%M-%S).log
find ./tmp-aed/*.{exe,msi} >> ./tmp-aed/aed-$(date +%Y.%m.%d-%H-%M-%S).log
sed 's/tmp-aed\///' -i ./tmp-aed/*.log


### move to destination ###
echo "<$(date +"%T")> Moving to destination..."
rm /active_pool/programs/auto-download/*.{exe,msi,log}   # You will need to edit this path
mv ./tmp-aed/*.{exe,msi,log} /active_pool/programs/auto-download/    # You will need to edit this path
chmod +x /active_pool/programs/auto-download/*.{exe,msi,log} # You will need to edit this path
unix2dos /active_pool/programs/auto-download/*.log
rm -r ./tmp-aed