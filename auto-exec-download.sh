#!/usr/bin/env bash
# github.com/OlJohnny | 2019

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace		# uncomment the previous statement for debugging


##### ENVIRONMENT VARIABLES #####
# please change THIS path to where you want the executeables to be copied to after auto-downloading
# in the directory you enter, a folder named 'logs' will be created and after a complete run of this script a log will be added there
# NOTE: do NOT put a '/' at the end
copyto=/path/for/execs/to/be/copied/to



##### FUNCTIONS #####
### install dos2unix function ###
_var1func(){
read --prompt $'\e[96mDo you want to install dos2unix? (Needed to correctly display the log file on windows systems) (y|n): \e[0m' var1
if [[ "${var1}" -eq "y" ]]
then
	echo -e "\e[92mInstalling dos2unix...\e[0m"
	apt-get --yes install dos2unix
elif [[ "${var1}" -eq "n" ]]
then
	echo -e "\e[91mPackage is needed to complete the run of this script.\e[0m"
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
	echo "Exiting..."
	exit
fi


### check environment variables ###
if [[ "${copyto}" == /path/for/execs/to/be/copied/to ]]
then
	echo -e "\e[91mPlease change environment variable in line 14.\e[39m Correctly set environment variable are needed to complete the run of this script"
	echo "Exiting..."
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
if [[ $(dpkg-query --show --showformat='${Status}' dos2unix 2>/dev/null | grep --count "ok installed") -eq 0 ]]
then
	_var1func
else
	echo -e "\e[92mPackage dos2unix is already installed\e[0m"
fi


### cleanup ###
rm --recursive --force ./tmp-aed
mkdir ./tmp-aed



##### DOWNLOAD OF FILES #####
### winrar ###
## download ##
echo -e "\n<$(date +"%T")> Getting WinRar...\e[90m"
# download exec
wget --quiet --output-document=- https://www.winrar.de/downld.php | grep --extended-regexp --only-matching --ignore-case '<a.+href="[^\"]+"' | grep --extended-regexp --only-matching '(http|https):\/\/winrar.*x64-[0-9]{3}d\.exe' | head --lines=1 | xargs wget --quiet --show-progress --directory-prefix=./tmp-aed/
echo -en "\e[0m"

## rename ##
echo -e "\e[90m<$(date +"%T")> Renaming...\e[0m"
echo "./tmp-aed/WinRAR " > ./tmp-aed/.exec-rename
wget --quiet --output-document=- https://www.winrar.de/downld.php | grep --extended-regexp --only-matching --ignore-case 'Aktuelle Version: WinRAR [0-9]\.[0-9]{1,2}' | head --lines=1 | grep --extended-regexp --only-matching '[0-9]\.[0-9]{1,2}' >> ./tmp-aed/.exec-rename
echo ".exe" >> ./tmp-aed/.exec-rename
sed --in-place ':a;N;$!ba;s/\n//g' ./tmp-aed/.exec-rename
cat ./tmp-aed/.exec-rename | xargs --replace={} mv ./tmp-aed/winrar-x64-*.exe {}
rm ./tmp-aed/.exec-*


### cpu-z ###
## download ##
echo -e "\e[0m\n<$(date +"%T")> Getting CPU-Z...\e[90m"
# get link to download page
echo "<$(date +"%T")> Getting Download Link..."
wget --quiet --output-document=- https://www.cpuid.com/softwares/cpu-z.html | grep --extended-regexp --only-matching --ignore-case '<a.+href="[^\"]+"' | grep --extended-regexp --only-matching '/downloads/cpu-z/cpu-z_[0-9]{1}\.[0-9]{2}-en\.exe' | head --lines=1 > ./tmp-aed/.exec-work
sed --in-place '1 i\https://www.cpuid.com' ./tmp-aed/.exec-work
sed --in-place ':a;N;$!ba;s/\n//g' ./tmp-aed/.exec-work
# download exec
wget --quiet --output-document=- --input-file=./tmp-aed/.exec-work | grep --extended-regexp --only-matching --ignore-case '<a.+href="[^\"]+"' | grep --extended-regexp --only-matching '(http|https)://download\.cpuid\.com/cpu-z/cpu-z_[0-9]\.[0-9]{1,2}-en\.exe' | head --lines=1 | xargs wget --quiet --show-progress --directory-prefix=./tmp-aed/
echo -en "\e[0m"

## rename ##
echo -e "\e[90m<$(date +"%T")> Renaming...\e[0m"
echo "./tmp-aed/CPU-Z " > ./tmp-aed/.exec-rename
wget --quiet --output-document=- --input-file=./tmp-aed/.exec-work | grep --extended-regexp --only-matching --ignore-case 'cpu-z_[0-9]\.[0-9]{1,2}-en\.exe' | head --lines=1 | grep --extended-regexp --only-matching '[0-9]\.[0-9]{1,2}' >> ./tmp-aed/.exec-rename
echo ".exe" >> ./tmp-aed/.exec-rename
sed --in-place ':a;N;$!ba;s/\n//g' ./tmp-aed/.exec-rename
cat ./tmp-aed/.exec-rename | xargs --replace={} mv ./tmp-aed/cpu-z_*.exe {}
rm ./tmp-aed/.exec-*


### hwmonitor ###
## download ##
echo -e "\e[0m\n<$(date +"%T")> Getting HWMonitor...\e[90m"
# get link to download page
echo "<$(date +"%T")> Getting Download Link..."
wget --quiet --output-document=- https://www.cpuid.com/softwares/hwmonitor.html | grep --extended-regexp --only-matching --ignore-case '<a.+href="[^\"]+"' | grep --extended-regexp --only-matching '/downloads/hwmonitor/hwmonitor_[0-9]{1}\.[0-9]{2}\.exe' | head --lines=1 > ./tmp-aed/.exec-work
sed --in-place '1 i\https://www.cpuid.com' ./tmp-aed/.exec-work
sed --in-place ':a;N;$!ba;s/\n//g' ./tmp-aed/.exec-work
# download exec
wget --quiet --output-document=- --input-file=./tmp-aed/.exec-work | grep --extended-regexp --only-matching --ignore-case '<a.+href="[^\"]+"' | grep --extended-regexp --only-matching '(http|https)://download\.cpuid\.com/hwmonitor/hwmonitor_[0-9]\.[0-9]{2}\.exe' | head --lines=1 | xargs wget --quiet --show-progress --directory-prefix=./tmp-aed/
echo -en "\e[0m"

## rename ##
echo -e "\e[90m<$(date +"%T")> Renaming...\e[0m"
echo "./tmp-aed/HWMonitor " > ./tmp-aed/.exec-rename
wget --quiet --output-document=- --input-file=./tmp-aed/.exec-work | grep --extended-regexp --only-matching --ignore-case 'hwmonitor_[0-9]\.[0-9]{1,2}\.exe' | head --lines=1 | grep --extended-regexp --only-matching '[0-9]\.[0-9]{1,2}' >> ./tmp-aed/.exec-rename
echo ".exe" >> ./tmp-aed/.exec-rename
sed --in-place ':a;N;$!ba;s/\n//g' ./tmp-aed/.exec-rename
cat ./tmp-aed/.exec-rename | xargs --replace={} mv ./tmp-aed/hwmonitor_*.exe {}
rm ./tmp-aed/.exec-*


### geforce experience ###
## download ##
echo -e "\e[0m\n<$(date +"%T")> Getting GeForce Experience...\e[90m"
# get link to download page
echo "<$(date +"%T")> Getting Download Link..."
wget --quiet --output-document=- https://www.nvidia.de/object/geforce-experience-download-de.html | grep --extended-regexp --only-matching --ignore-case '<a.+href="[^\"]+"' | grep --extended-regexp --only-matching '//de\.download\.nvidia\.com/GFE/GFEClient/.*\.exe' | head --lines=1 > ./tmp-aed/.exec-work
sed --in-place '1 i\https:' ./tmp-aed/.exec-work
sed --in-place ':a;N;$!ba;s/\n//g' ./tmp-aed/.exec-work
# download exec
wget --quiet --show-progress --input-file=./tmp-aed/.exec-work --directory-prefix=./tmp-aed/
echo -en "\e[0m"

## rename ##
echo -e "\e[90m<$(date +"%T")> Renaming...\e[0m"
echo "./tmp-aed/GeForce Experience " > ./tmp-aed/.exec-rename
wget --quiet --output-document=- https://www.nvidia.de/object/geforce-experience-download-de.html | grep --extended-regexp --only-matching --ignore-case 'Version:.*[0-9]\.[0-9]{1,2}\.[0-9]{1,2}\.[0-9]{1,3}' | head --lines=1 | grep --extended-regexp --only-matching '[0-9]\.[0-9]{1,2}\.[0-9]{1,2}\.[0-9]{1,3}' >> ./tmp-aed/.exec-rename
echo ".exe" >> ./tmp-aed/.exec-rename
sed --in-place ':a;N;$!ba;s/\n//g' ./tmp-aed/.exec-rename
cat ./tmp-aed/.exec-rename | xargs --replace={} mv ./tmp-aed/GeForce_Experience_*.exe {}
rm ./tmp-aed/.exec-*


### putty ###
## download ##
echo -e "\e[0m\n<$(date +"%T")> Getting PuTTY...\e[90m"
# download exec
wget --quiet --output-document=- https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html | grep --extended-regexp --only-matching --ignore-case '<a.+href="[^\"]+"' | grep --extended-regexp --only-matching 'https://the\.earth\.li/~sgtatham/putty/latest/w64/putty-64bit-[0-9]\.[0-9]{2}-installer\.msi' | head --lines=1 | xargs wget --quiet --show-progress --directory-prefix=./tmp-aed/
echo -en "\e[0m"

## rename ##
echo -e "\e[90m<$(date +"%T")> Renaming...\e[0m"
echo "./tmp-aed/PuTTY " > ./tmp-aed/.exec-rename
wget --quiet --output-document=- https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html | grep --extended-regexp --only-matching --ignore-case 'Currently this is [0-9]\.[0-9]{1,2}' | head --lines=1 | grep --extended-regexp --only-matching '[0-9]\.[0-9]{1,2}' >> ./tmp-aed/.exec-rename
echo ".msi" >> ./tmp-aed/.exec-rename
sed --in-place ':a;N;$!ba;s/\n//g' ./tmp-aed/.exec-rename
cat ./tmp-aed/.exec-rename | xargs --replace={} mv ./tmp-aed/putty-64bit-*-installer.msi {}
rm ./tmp-aed/.exec-*


### vlc ###
## download ##
echo -e "\e[0m\n<$(date +"%T")> Getting VLC...\e[90m"
# get link to download page
echo "<$(date +"%T")> Getting Download Link..."
wget --quiet --output-document=- https://www.vlc.de/vlc_download_64bit.php | grep --extended-regexp --only-matching --ignore-case '<a.+href="[^\"]+"' | grep --extended-regexp --only-matching '//files\.vlc\.de/vlc/vlc-[0-9]\.[0-9]\.[0-9]-win64\.exe' | head --lines=1 > ./tmp-aed/.exec-work
sed --in-place '1 i\https:' ./tmp-aed/.exec-work
sed --in-place ':a;N;$!ba;s/\n//g' ./tmp-aed/.exec-work
# download exec
wget --quiet --show-progress --input-file=./tmp-aed/.exec-work --directory-prefix=./tmp-aed/
echo -en "\e[0m"

## rename ##
echo -e "\e[90m<$(date +"%T")> Renaming...\e[0m"
echo "./tmp-aed/VLC " > ./tmp-aed/.exec-rename
wget --quiet --output-document=- https://www.vlc.de/vlc_download_64bit.php | grep --extended-regexp --only-matching --ignore-case 'Media Player V[0-9]\.[0-9]\.[0-9]{1,2}' | head --lines=1 | grep --extended-regexp --only-matching '[0-9]\.[0-9]\.[0-9]{1,2}' >> ./tmp-aed/.exec-rename
echo ".exe" >> ./tmp-aed/.exec-rename
sed --in-place ':a;N;$!ba;s/\n//g' ./tmp-aed/.exec-rename
cat ./tmp-aed/.exec-rename | xargs --replace={} mv ./tmp-aed/vlc-*-win64.exe {}
rm ./tmp-aed/.exec-*


### mp3tag ###
## download ##
echo -e "\e[0m\n<$(date +"%T")> Getting Mp3tag...\e[90m"
# download exec
wget --quiet --output-document=- https://www.mp3tag.de/dodownload.html | sed --expression=':a;N;$!ba;s/\s\{2\}\n//g' | grep --extended-regexp --only-matching --ignore-case '<a.+href="[^\"]+"' | grep --extended-regexp --only-matching 'https://download\.mp3tag\.de/mp3tagv[0-9]{3}setup\.exe' | head --lines=1 | xargs wget --quiet --show-progress --directory-prefix=./tmp-aed/
echo -en "\e[0m"

## rename ##
echo -e "\e[90m<$(date +"%T")> Renaming...\e[0m"
echo "./tmp-aed/Mp3tag " > ./tmp-aed/.exec-rename
wget --quiet --output-document=- https://www.mp3tag.de/en/download.html | grep --extended-regexp --only-matching --ignore-case 'Mp3tag v[0-9]\.[0-9]{1,2}' | head --lines=1 | grep --extended-regexp --only-matching '[0-9]\.[0-9]{1,2}' >> ./tmp-aed/.exec-rename
echo ".exe" >> ./tmp-aed/.exec-rename
sed --in-place ':a;N;$!ba;s/\n//g' ./tmp-aed/.exec-rename
cat ./tmp-aed/.exec-rename | xargs --replace={} mv ./tmp-aed/mp3tagv*setup.exe {}
rm ./tmp-aed/.exec-*


### jre ###
## download ##
echo -e "\e[0m\n<$(date +"%T")> Getting Java (JRE)...\e[90m"
# download exec
wget --quiet --output-document=- https://java.com/de/download/manual.jsp | grep --extended-regexp --only-matching --ignore-case '<a title="Download der Java-Software für Windows \(64-Bit\)" href="[^\"]+"' | grep --extended-regexp --only-matching 'https://javadl\.oracle\.com/webapps/download/AutoDL\?BundleId=[0-9]{6}_([0-9]|[a-z]){32}' | head --lines=1 | xargs wget --quiet --show-progress --directory-prefix=./tmp-aed/
echo -en "\e[0m"

## rename ##
echo -e "\e[90m<$(date +"%T")> Renaming...\e[0m"
echo "./tmp-aed/JRE " > ./tmp-aed/.exec-rename
wget --quiet --output-document=- https://java.com/de/download/manual.jsp | grep --extended-regexp --only-matching --ignore-case 'Version [0-9] Update [0-9]{1,3}' | sed --regexp-extended 's/Version //;s/ Update /\./' | head --lines=1 >> ./tmp-aed/.exec-rename
echo ".exe" >> ./tmp-aed/.exec-rename
sed --in-place ':a;N;$!ba;s/\n//g' ./tmp-aed/.exec-rename
cat ./tmp-aed/.exec-rename | xargs --replace={} mv ./tmp-aed/AutoDL\?BundleId\=* {}
rm ./tmp-aed/.exec-*


### notepad++ ###
## download ##
echo -e "\e[0m\n<$(date +"%T")> Getting Notepad++...\e[90m"
# get link to download page
echo "<$(date +"%T")> Getting Download Link..."
wget --quiet --output-document=- https://notepad-plus-plus.org/download | grep --extended-regexp --only-matching --ignore-case '<a.+href="[^\"]+"' | grep --extended-regexp --only-matching '/repository/[0-9]\.x/[0-9]\.[0-9](\.[0-9])?/npp\.[0-9]\.[0-9](\.[0-9])?\.Installer\.x64\.exe' | head --lines=1 > ./tmp-aed/.exec-work
sed --in-place '1 i\https://notepad-plus-plus.org' ./tmp-aed/.exec-work
sed --in-place ':a;N;$!ba;s/\n//g' ./tmp-aed/.exec-work
# download exec
wget --quiet --show-progress --input-file=./tmp-aed/.exec-work --directory-prefix=./tmp-aed/
echo -en "\e[0m"
rm ./tmp-aed/.exec-work

## rename ##
echo -e "\e[90m<$(date +"%T")> Renaming...\e[0m"
echo "./tmp-aed/Notepad++ " > ./tmp-aed/.exec-rename
wget --quiet --output-document=- https://notepad-plus-plus.org/download | grep --extended-regexp --only-matching --ignore-case 'Download Notepad\+\+ [0-9]\.[0-9](\.[0-9])?' | head --lines=1 | grep --extended-regexp --only-matching '[0-9]\.[0-9](\.[0-9])?' >> ./tmp-aed/.exec-rename
echo ".exe" >> ./tmp-aed/.exec-rename
sed --in-place ':a;N;$!ba;s/\n//g' ./tmp-aed/.exec-rename
cat ./tmp-aed/.exec-rename | xargs --replace={} mv ./tmp-aed/npp.*.Installer.x64.exe {}
rm ./tmp-aed/.exec-*


### balenaetcher ###
## download ##
echo -e "\e[0m\n<$(date +"%T")> Getting Balena Etcher...\e[90m"
# get link to download page
echo "<$(date +"%T")> Getting Download Link..."
wget --quiet --output-document=- https://github.com/balena-io/etcher/releases | grep --extended-regexp --only-matching --ignore-case '<a.+href="[^\"]+"' | grep --extended-regexp --only-matching '/balena-io/etcher/releases/download/v[0-9]\.[0-9]\.[0-9]{1,2}/balenaEtcher-Setup-[0-9]\.[0-9]\.[0-9]{1,2}-x64\.exe' | head --lines=1 > ./tmp-aed/.exec-work
sed --in-place '1 i\https://github\.com' ./tmp-aed/.exec-work
sed --in-place ':a;N;$!ba;s/\n//g' ./tmp-aed/.exec-work
# download exec
wget --quiet --show-progress --input-file=./tmp-aed/.exec-work --directory-prefix=./tmp-aed/
echo -en "\e[0m"

## rename ##
echo -e "\e[90m<$(date +"%T")> Renaming...\e[0m"
echo "./tmp-aed/balenaEtcher " > ./tmp-aed/.exec-rename
wget --quiet --output-document=- https://github.com/balena-io/etcher/releases | grep --extended-regexp --only-matching --ignore-case 'v[0-9]\.[0-9]\.[0-9]{1,2}' | head --lines=1 | grep --extended-regexp --only-matching '[0-9]\.[0-9]\.[0-9]{1,2}' >> ./tmp-aed/.exec-rename
echo ".exe" >> ./tmp-aed/.exec-rename
sed --in-place ':a;N;$!ba;s/\n//g' ./tmp-aed/.exec-rename
cat ./tmp-aed/.exec-rename | xargs --replace={} mv ./tmp-aed/balenaEtcher-Setup-*-x64.exe {}
rm ./tmp-aed/.exec-*


### teamspeak 3 client ###
## download ##
echo -e "\e[0m\n<$(date +"%T")> Getting Teamspeak 3 Client...\e[90m"
# download exec
wget --quiet --output-document=- https://www.teamspeak.de/download/teamspeak-3-64-Bit-client-windows/ | grep --extended-regexp --only-matching --ignore-case '<a.+href="[^\"]+"' | grep --extended-regexp --only-matching 'http://dl\.4players\.de/ts/releases/[0-9]\.[0-9]\.[0-9]/TeamSpeak3-Client-win64-[0-9]\.[0-9]\.[0-9]\.exe' | head --lines=1 | xargs wget --quiet --show-progress --directory-prefix=./tmp-aed/
echo -en "\e[0m"

## rename ##
echo -e "\e[90m<$(date +"%T")> Renaming...\e[0m"
echo "./tmp-aed/Teamspeak 3 Client " > ./tmp-aed/.exec-rename
wget --quiet --output-document=- https://www.teamspeak.de/download/teamspeak-3-64-Bit-client-windows/ | grep --extended-regexp --only-matching --ignore-case 'TS3 Win64 Client [0-9]\.[0-9]\.[0-9]' | head --lines=1 | grep --extended-regexp --only-matching '[0-9]\.[0-9]\.[0-9]' >> ./tmp-aed/.exec-rename
echo ".exe" >> ./tmp-aed/.exec-rename
sed --in-place ':a;N;$!ba;s/\n//g' ./tmp-aed/.exec-rename
cat ./tmp-aed/.exec-rename | xargs --replace={} mv ./tmp-aed/TeamSpeak3-Client-win64-*.exe {}
rm ./tmp-aed/.exec-*


### filezilla ###
## download ##
echo -e "\e[0m\n<$(date +"%T")> Getting FileZilla...\e[90m"
# download exec
wget --quiet --output-document=- --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64)" https://filezilla-project.org/download.php?type=client | grep --extended-regexp --only-matching --ignore-case '<a.+href="[^\"]+"' | grep --extended-regexp --only-matching 'https://download\.filezilla-project\.org/client/FileZilla_[0-9]\.[0-9]{2}\.[0-9]_win64_sponsored-setup\.exe' | head --lines=1 | xargs wget --quiet --show-progress --directory-prefix=./tmp-aed/
echo -en "\e[0m"

## rename ##
echo -e "\e[90m<$(date +"%T")> Renaming...\e[0m"
echo "./tmp-aed/FileZilla " > ./tmp-aed/.exec-rename
wget --quiet --output-document=- --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64)" https://filezilla-project.org/download.php?type=client | grep --extended-regexp --only-matching --ignore-case 'FileZilla Client is [0-9]\.[0-9]{1,2}\.[0-9]' | head --lines=1 | grep --extended-regexp --only-matching '[0-9]\.[0-9]{1,2}\.[0-9]' >> ./tmp-aed/.exec-rename
echo ".exe" >> ./tmp-aed/.exec-rename
sed --in-place ':a;N;$!ba;s/\n//g' ./tmp-aed/.exec-rename
cat ./tmp-aed/.exec-rename | xargs --replace={} mv ./tmp-aed/FileZilla_*_win64_sponsored-setup.exe {}
rm ./tmp-aed/.exec-*


### keepass ###
## download ##
echo -e "\e[0m\n<$(date +"%T")> Getting KeePass...\e[90m"
# get link to download page
echo "<$(date +"%T")> Getting Download Link..."
wget --quiet --output-document=- --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64)" https://sourceforge.net/projects/keepass/files/KeePass%202.x/ | grep --extended-regexp --only-matching --ignore-case '<a.+href="[^\"]+"' | grep --extended-regexp --only-matching '/projects/keepass/files/KeePass%202\.x/[0-9]\.[0-9]{1,2}\.[0-9]/' | head --lines=1 > ./tmp-aed/.exec-work
sed --in-place '1 i\https://sourceforge\.net' ./tmp-aed/.exec-work
sed --in-place ':a;N;$!ba;s/\n//g' ./tmp-aed/.exec-work
# get link to download page
wget --quiet --output-document=- --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64)" --input-file=./tmp-aed/.exec-work | grep --extended-regexp --only-matching --ignore-case '<a.+href="[^\"]+"' | grep --extended-regexp --only-matching 'https://sourceforge\.net/projects/keepass/files/KeePass%202\.x/[0-9]\.[0-9]{1,2}\.[0-9]/KeePass-[0-9]\.[0-9]{1,2}\.[0-9]-Setup\.exe' | head --lines=1 > ./tmp-aed/.exec-work1
sed --in-place 's|https://sourceforge.net/projects/keepass/files/|https://netcologne.dl.sourceforge.net/project/keepass/|' ./tmp-aed/.exec-work1
# download exec
wget --quiet --show-progress --input-file=./tmp-aed/.exec-work1 --directory-prefix=./tmp-aed/
echo -en "\e[0m"

## rename ##
echo -e "\e[90m<$(date +"%T")> Renaming...\e[0m"
echo "./tmp-aed/KeePass " > ./tmp-aed/.exec-rename
wget --quiet --output-document=- --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64)" https://sourceforge.net/projects/keepass/files/ | grep --extended-regexp --only-matching --ignore-case 'KeePass-[0-9]\.[0-9]{1,2}\.[0-9]-Setup\.exe' | head --lines=1 | grep --extended-regexp --only-matching '[0-9]\.[0-9]{1,2}\.[0-9]' >> ./tmp-aed/.exec-rename
echo ".exe" >> ./tmp-aed/.exec-rename
sed --in-place ':a;N;$!ba;s/\n//g' ./tmp-aed/.exec-rename
cat ./tmp-aed/.exec-rename | xargs --replace={} mv ./tmp-aed/KeePass-*-Setup.exe {}
rm ./tmp-aed/.exec-*


### crystaldiskinfo ###
## download ##
echo -e "\e[0m\n<$(date +"%T")> Getting CrystalDiskInfo...\e[90m"
# get link to download page
echo "<$(date +"%T")> Getting Download Link..."
wget --quiet --output-document=- https://osdn.net/projects/crystaldiskinfo/releases/ | grep --extended-regexp --only-matching --ignore-case '<a.+href="[^\"]+"' | grep --extended-regexp --only-matching '/projects/crystaldiskinfo/downloads/[0-9]{5}/CrystalDiskInfo[0-9]_[0-9]_[0-9]\.zip/' | grep --extended-regexp --only-matching '[0-9]{5}/CrystalDiskInfo[0-9]_[0-9]_[0-9]' | head --lines=1 > ./tmp-aed/.exec-work
sed --in-place '1 i\https://osdn\.net/frs/redir\.php?f=crystaldiskinfo/' ./tmp-aed/.exec-work
echo ".exe" >> ./tmp-aed/.exec-work
sed --in-place ':a;N;$!ba;s/\n//g' ./tmp-aed/.exec-work
# download exec
wget --quiet --show-progress --input-file=./tmp-aed/.exec-work --directory-prefix=./tmp-aed/
echo -en "\e[0m"

## rename ##
echo -e "\e[90m<$(date +"%T")> Renaming...\e[0m"
echo "./tmp-aed/" > ./tmp-aed/.exec-rename
wget --quiet --output-document=- https://osdn.net/projects/crystaldiskinfo/ | grep --extended-regexp --only-matching --ignore-case 'CrystalDiskInfo [0-9]\.[0-9]\.[0-9]' | head --lines=1 >> ./tmp-aed/.exec-rename
echo ".exe" >> ./tmp-aed/.exec-rename
sed --in-place ':a;N;$!ba;s/\n//g' ./tmp-aed/.exec-rename
cat ./tmp-aed/.exec-rename | xargs --replace={} mv ./tmp-aed/*CrystalDiskInfo*.exe {}
rm ./tmp-aed/.exec-*


### crystaldiskmark ###
## download ##
echo -e "\e[0m\n<$(date +"%T")> Getting CrystalDiskMark...\e[90m"
# get link to download page
echo "<$(date +"%T")> Getting Download Link..."
wget --quiet --output-document=- https://osdn.net/projects/crystaldiskmark/releases/ | grep --extended-regexp --only-matching --ignore-case '<a.+href="[^\"]+"' | grep --extended-regexp --only-matching '/projects/crystaldiskmark/downloads/[0-9]{5}/CrystalDiskMark[0-9]_[0-9]_[0-9]\.zip/' | grep --extended-regexp --only-matching '[0-9]{5}/CrystalDiskMark[0-9]_[0-9]_[0-9]' | head --lines=1 > ./tmp-aed/.exec-work
sed --in-place '1 i\https://osdn\.net/frs/redir\.php?f=crystaldiskmark/' ./tmp-aed/.exec-work
echo ".exe" >> ./tmp-aed/.exec-work
sed --in-place ':a;N;$!ba;s/\n//g' ./tmp-aed/.exec-work
# download exec
wget --quiet --show-progress --input-file=./tmp-aed/.exec-work --directory-prefix=./tmp-aed/
echo -en "\e[0m"

## rename ##
echo -e "\e[90m<$(date +"%T")> Renaming...\e[0m"
echo "./tmp-aed/" > ./tmp-aed/.exec-rename
wget --quiet --output-document=- https://osdn.net/projects/crystaldiskmark/ | grep --extended-regexp --only-matching --ignore-case 'CrystalDiskMark [0-9]\.[0-9]\.[0-9]' | head --lines=1 >> ./tmp-aed/.exec-rename
echo ".exe" >> ./tmp-aed/.exec-rename
sed --in-place ':a;N;$!ba;s/\n//g' ./tmp-aed/.exec-rename
cat ./tmp-aed/.exec-rename | xargs --replace={} mv ./tmp-aed/*crystaldiskmark*.exe {}
rm ./tmp-aed/.exec-*


### TODO ###
# OBS Studio
# GPU-Z
# Sumatra PDF
# Subtitle Edit
# MKV Tool Nix
# MikTex
# AutoHotKey
# Avidemux
# Audacity (not possible by fosshub)
# TeXMaker (low priority, as there hasn't been an update in years)
# MKV Cleaver (low priority, as there hasn't been an update in years)
# WinDirStat (low priority, as there hasn't been an update in years)



##### FINISHING #####
### making log ###
echo -e "\e[92m"
touch ./tmp-aed/aed-$(date +%Y.%m.%d-%H.%M.%S).log
echo "Successfully downloaded $(find ./tmp-aed/*.{exe,msi} | wc --lines)/16 programms" | tee ./tmp-aed/aed-*.log
echo -e "\e[0m"
find ./tmp-aed/*.{exe,msi} >> ./tmp-aed/aed-*.log
sed --in-place 's/tmp-aed\///' ./tmp-aed/aed-*.log
echo -e "\nNew Versions:" >> ./tmp-aed/aed-*.log

for i in winrar cpu-z hwmonitor geforce[[:space:]]experience putty vlc mp3tag jre notepad++ balenaetcher teamspeak[[:space:]]3[[:space:]]client filezilla keepass audacity crystaldiskinfo crystaldiskmark
do
if [[ "$(find "${copyto}"/*.{exe,msi} | sed "s|"${copyto}"||" | (grep --ignore-case "${i}" || echo ""${i}" not downloaded"))" != "$(find ./tmp-aed/*.{exe,msi} | sed "s|./tmp-aed||" | (grep --ignore-case "${i}" || echo "not present"))" ]]
then
	echo ""$(find ./tmp-aed/*.{exe,msi} | sed "s|./tmp-aed||" | (grep --ignore-case "${i}" || echo ""${i}" not downloaded"))" from "$(find "${copyto}"/*.{exe,msi} | sed "s|"${copyto}"||" | (grep --ignore-case "${i}" || echo "not present"))"" >> ./tmp-aed/aed-*.log
fi
done


### move to destination ###
# The intention is to move the downloaded executables to a network share
echo -e "<$(date +"%T")> Moving to destination..."
if [[ ! -d ""${copyto}"/logs" ]]
then
	mkdir "${copyto}"/logs
fi

rm "${copyto}"/*.{exe,msi}
mv ./tmp-aed/*.{exe,msi} "${copyto}"
unix2dos --quiet ./tmp-aed/*.log
mv ./tmp-aed/*.log "${copyto}"/logs
# set fitting permissions to executables
chmod +x "${copyto}"/*.{exe,msi}
# set fitting permissions to logs
chmod +x "${copyto}"/logs/*.log
rm --recursive ./tmp-aed