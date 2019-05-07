#!/usr/bin/env bash
# github.com/OlJohnny | 2019

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace		# uncomment the previous statement for debugging



##### FUNCTIONS #####
### install dos2unix function ###
_var1func(){
read --prompt "Do you want to install dos2unix? (Needed to correctly display the log file on windows systems) (y|n): " var1
if [[ "${var1}" -eq "y" ]]
then
	echo "Installing dos2unix..."
	apt-get --yes install dos2unix
elif [[ "${var1}" -eq "n" ]]
then
	echo "Package is needed to complete the run of this script."
	echo "Exiting..."
	exit
else
	_var1func
fi
}



##### PREPARATION #####
### check for root privilges ###
if [[ "${EUID}" -ne 0 ]]
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

if [[ $(dpkg-query --show --showformat='${Status}' dos2unix 2>/dev/null | grep --count "ok installed") -eq 0 ]];
then
	_var1func
else
	echo "Package dos2unix is already installed"
fi


### cleanup ###
rm --recursive --force ./tmp-aed
mkdir ./tmp-aed



##### DOWNLOAD OF FILES #####
### winrar ###
echo "<$(date +"%T")> Getting WinRar..."
wget --quiet --output-document=- https://www.winrar.de/downld.php | grep --extended-regexp --only-matching --ignore-case '<a.+href="[^\"]+"' | grep --extended-regexp --only-matching '(http|https):\/\/winrar.*x64-[0-9]{3}d\.exe' | head --lines=1 | xargs wget --quiet --directory-prefix=./tmp-aed/


### cpu-z ###
echo "<$(date +"%T")> Getting CPU-Z..."
wget --quiet --output-document=- https://www.cpuid.com/softwares/cpu-z.html | grep --extended-regexp --only-matching --ignore-case '<a.+href="[^\"]+"' | grep --extended-regexp --only-matching '/downloads/cpu-z/cpu-z_[0-9]{1}\.[0-9]{2}-en\.exe' | head --lines=1 > ./tmp-aed/.exec-work
sed --in-place '1 i\https://www.cpuid.com' ./tmp-aed/.exec-work
sed --in-place ':a;N;$!ba;s/\n//g' ./tmp-aed/.exec-work
wget --quiet --output-document=- --input-file=./tmp-aed/.exec-work | grep --extended-regexp --only-matching --ignore-case '<a.+href="[^\"]+"' | grep --extended-regexp --only-matching '(http|https)://download\.cpuid\.com/cpu-z/cpu-z_[0-9]\.[0-9]{2}-en\.exe' | head --lines=1 | xargs wget --quiet --directory-prefix=./tmp-aed/
rm ./tmp-aed/.exec-work


### hwmonitor ###
echo "<$(date +"%T")> Getting HWMonitor..."
wget --quiet --output-document=- https://www.cpuid.com/softwares/hwmonitor.html | grep --extended-regexp --only-matching --ignore-case '<a.+href="[^\"]+"' | grep --extended-regexp --only-matching '/downloads/hwmonitor/hwmonitor_[0-9]{1}\.[0-9]{2}\.exe' | head --lines=1 > ./tmp-aed/.exec-work
sed --in-place '1 i\https://www.cpuid.com' ./tmp-aed/.exec-work
sed --in-place ':a;N;$!ba;s/\n//g' ./tmp-aed/.exec-work
wget --quiet --output-document=- --input-file=./tmp-aed/.exec-work | grep --extended-regexp --only-matching --ignore-case '<a.+href="[^\"]+"' | grep --extended-regexp --only-matching '(http|https)://download\.cpuid\.com/hwmonitor/hwmonitor_[0-9]\.[0-9]{2}\.exe' | head --lines=1 | xargs wget --quiet --directory-prefix=./tmp-aed/
rm ./tmp-aed/.exec-work


### geforce experience ###
echo "<$(date +"%T")> Getting GeForce Experience..."
wget --quiet --output-document=- https://www.nvidia.de/object/geforce-experience-download-de.html | grep --extended-regexp --only-matching --ignore-case '<a.+href="[^\"]+"' | grep --extended-regexp --only-matching '//de\.download\.nvidia\.com/GFE/GFEClient/.*\.exe' | head --lines=1 > ./tmp-aed/.exec-work
sed --in-place '1 i\https:' ./tmp-aed/.exec-work
sed --in-place ':a;N;$!ba;s/\n//g' ./tmp-aed/.exec-work
wget --quiet --input-file=./tmp-aed/.exec-work --directory-prefix=./tmp-aed/
rm ./tmp-aed/.exec-work


### putty ###
echo "<$(date +"%T")> Getting PuTTY..."
wget --quiet --output-document=- https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html | grep --extended-regexp --only-matching --ignore-case '<a.+href="[^\"]+"' | grep --extended-regexp --only-matching 'https://the\.earth\.li/~sgtatham/putty/latest/w64/putty-64bit-[0-9]\.[0-9]{2}-installer\.msi' | head --lines=1 | xargs wget --quiet --directory-prefix=./tmp-aed/


### vlc ###
echo "<$(date +"%T")> Getting VLC..."
wget --quiet --output-document=- https://www.vlc.de/vlc_download_64bit.php | grep --extended-regexp --only-matching --ignore-case '<a.+href="[^\"]+"' | grep --extended-regexp --only-matching '//files\.vlc\.de/vlc/vlc-[0-9]\.[0-9]\.[0-9]-win64\.exe' | head --lines=1 > ./tmp-aed/.exec-work
sed --in-place '1 i\https:' ./tmp-aed/.exec-work
sed --in-place ':a;N;$!ba;s/\n//g' ./tmp-aed/.exec-work
wget --quiet --input-file=./tmp-aed/.exec-work --directory-prefix=./tmp-aed/
rm ./tmp-aed/.exec-work


### mp3tag ###
echo "<$(date +"%T")> Getting MP3Tag..."
wget --quiet --output-document=- https://www.mp3tag.de/dodownload.html | sed --expression=':a;N;$!ba;s/\s\{2\}\n//g' | grep --extended-regexp --only-matching --ignore-case '<a.+href="[^\"]+"' | grep --extended-regexp --only-matching 'https://download\.mp3tag\.de/mp3tagv[0-9]{3}setup\.exe' | head --lines=1 | xargs wget --quiet --directory-prefix=./tmp-aed/


### java ###
echo "<$(date +"%T")> Getting Java (JRE)..."
wget --quiet --output-document=- https://java.com/de/download/manual.jsp | grep --extended-regexp --only-matching --ignore-case '<a title="Download der Java-Software für Windows \(64-Bit\)" href="[^\"]+"' | grep --extended-regexp --only-matching 'https://javadl\.oracle\.com/webapps/download/AutoDL\?BundleId=[0-9]{6}_([0-9]|[a-z]){32}' | head --lines=1 | xargs wget --quiet --directory-prefix=./tmp-aed/
echo "./tmp-aed/JRE " > ./tmp-aed/.exec-work
wget --quiet --output-document=- https://java.com/de/download/manual.jsp | grep --extended-regexp --only-matching --ignore-case 'Version [0-9] Update [0-9]{3}' | head --lines=1 >> ./tmp-aed/.exec-work
echo ".exe" >> ./tmp-aed/.exec-work
sed --in-place ':a;N;$!ba;s/\n//g' ./tmp-aed/.exec-work
cat ./tmp-aed/.exec-work | xargs --replace={} mv ./tmp-aed/AutoDL\?BundleId\=* {}
rm ./tmp-aed/.exec-work


### notepad++ ###
echo "<$(date +"%T")> Getting Notepad++..."
wget --quiet --output-document=- https://notepad-plus-plus.org/download | grep --extended-regexp --only-matching --ignore-case '<a.+href="[^\"]+"' | grep --extended-regexp --only-matching '/repository/[0-9]\.x/[0-9]\.[0-9]\.[0-9]/npp\.[0-9]\.[0-9]\.[0-9]\.Installer\.x64\.exe' | head --lines=1 > ./tmp-aed/.exec-work
sed --in-place '1 i\https://notepad-plus-plus.org' ./tmp-aed/.exec-work
sed --in-place ':a;N;$!ba;s/\n//g' ./tmp-aed/.exec-work
wget --quiet --input-file=./tmp-aed/.exec-work --directory-prefix=./tmp-aed/
rm ./tmp-aed/.exec-work


### balena etcher ###
echo "<$(date +"%T")> Getting Balena Etcher..."
wget --quiet --output-document=- https://www.balena.io/etcher/ | grep --extended-regexp --only-matching --ignore-case '<a.+href="[^\"]+"' | grep --extended-regexp --only-matching 'https://github\.com/balena-io/etcher/releases/download/v[0-9]\.[0-9]\.[0-9]{2}/balenaEtcher-Setup-[0-9]\.[0-9]\.[0-9]{2}-x64\.exe' | head --lines=1 | xargs wget --quiet --directory-prefix=./tmp-aed/


### teamspeak client ###
echo "<$(date +"%T")> Getting Teamspeak Client..."
wget --quiet --output-document=- https://www.teamspeak.de/download/teamspeak-3-64-Bit-client-windows/ | grep --extended-regexp --only-matching --ignore-case '<a.+href="[^\"]+"' | grep --extended-regexp --only-matching 'http://dl\.4players\.de/ts/releases/[0-9]\.[0-9]\.[0-9]/TeamSpeak3-Client-win64-[0-9]\.[0-9]\.[0-9]\.exe' | head --lines=1 | xargs wget --quiet --directory-prefix=./tmp-aed/


### filezilla ###
echo "<$(date +"%T")> Getting FileZilla..."
wget --quiet --output-document=- --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64)" https://filezilla-project.org/download.php?type=client | grep --extended-regexp --only-matching --ignore-case '<a.+href="[^\"]+"' | grep --extended-regexp --only-matching 'https://download\.filezilla-project\.org/client/FileZilla_[0-9]\.[0-9]{2}\.[0-9]_win64_sponsored-setup\.exe' | head --lines=1 | xargs wget --quiet --directory-prefix=./tmp-aed/



### TODO ###
# CrystalDiskInfo/Mark
# OBS Studio
# GPU-Z
# WinDirStat
# KeePass (Difficulties with Sourceforge)



##### FINISHING #####
### making log ###
echo "Successfully downloaded $(find ./tmp-aed/*.{exe,msi} | wc --lines)/12 programms:" | tee ./tmp-aed/aed-$(date +%Y.%m.%d-%H-%M-%S).log
find ./tmp-aed/*.{exe,msi} >> ./tmp-aed/aed-$(date +%Y.%m.%d-%H-%M-%S).log
sed --in-place 's/tmp-aed\///' ./tmp-aed/*.log


### move to destination ###
echo "<$(date +"%T")> Moving to destination..."
rm /active_pool/programs/auto-download/*.{exe,msi,log}   # You will need to edit this path
mv ./tmp-aed/*.{exe,msi,log} /active_pool/programs/auto-download/    # You will need to edit this path
chmod +x /active_pool/programs/auto-download/*.{exe,msi,log} # You will need to edit this path
unix2dos --quiet /active_pool/programs/auto-download/*.log
rm --recursive ./tmp-aed