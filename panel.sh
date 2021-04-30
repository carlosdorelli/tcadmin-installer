# Installing dependencies
echo -e ""
echo -e ""
echo -e "TCAdmin Auto Installer"
echo -e "https://eldremor.com"
echo -e ""
echo -e ""
echo -e "1. Installing the dependencies of the panel"
echo -e ""
apt update;
apt upgrade;
apt install gnupg ca-certificates;
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF;
echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list;
apt update;
apt-get install mono-complete mono-vbnc mono-xsp;
apt-get install lib32stdc++6;
apt-get install libpcap0.8 util-linux lsof screen iptables-persistent;
apt-get install libpcap0.8 util-linux lsof;
apt-get install libncurses5 libncurses5:i386;
apt install default-jre;