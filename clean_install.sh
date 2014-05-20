echo "Ensuring system is up to date"
yum -y update

cd /home/$USERNAME/Downloads
echo "Install Preliminary Packages"
yum install --nogpgcheck -y wget kernel-devel sox

echo "Downloading Packages to install"
wget http://www.dcuonline.co.uk/m1n3/clean_install.zip

unzip clean_install.zip
cd clean_install 

echo "Install EPEL, Atomic and RPMFORGE Repositories"
yum --nogpgcheck localinstall -y epel-release-6-8.noarch.rpm
yum --nogpgcheck localinstall -y rpmforge-release-0.5.2-2.el6.rf.x86_64.rpm
wget -q -O - http://www.atomicorp.com/installers/atomic | sh

 
echo "Clean up yum db"
yum clean all


mv -f .bashrc /home/$USERNAME

echo "Install Web Development Tools"
yum -y groupinstall "Development tools" "Console internet tools"

echo "Install Ruby and Rubygems"
echo "Installing Ruby and Libraries"
yum -y install ruby gcc gcc-c++.x86_64 libyaml-devel libffi-devel libtool bison mingw32-iconv-static.noarch perl-Text-Iconv.x86_64 libsidplay-devel.x86_64 patch readline readline-devel make automake autoconf curl-devel openssl-devel zlib-devel httpd-devel apr-devel apr-util-devel sqlite-devel ruby-rdoc ruby-devel rubygems

echo "Installing Rubygems"
curl -L get.rvm.io | bash -s stable
source /home/$USERNAME/.rvm/scripts/rvm
rvm reload
rvm install 2.1.2
rvm use 2.1.2 --default
echo "Default Ruby Environment is now:"
ruby --version

gem install capistrano

echo "Install Background Engines and Libraries"
yum --nogpgcheck -y install gtk2.x86_64 gtk2-engines-devel.x86_64 gtk2-engines-devel.x86_64  libXtst.x86_64 libXtst-devel.x86_64

echo "Install JDK 7 for use with SQL Developer"
yum --nogpgcheck localinstall -y jdk-7u55-linux-x64.rpm

echo "Installing latest JDK (as of May 2014)"
yum --nogpgcheck localinstall -y jdk-8u5-linux-x64.rpm

echo "Installing JRE"
yum --nogpgcheck localinstall -y jre-8u5-linux-x64.rpm

echo "Installing Sql Developer"
yum --nogpgcheck localinstall -y sqldeveloper-4.0.2.15.21-1.noarch.rpm

echo "Installing MySQL Workbench"
yum --nogpgcheck localinstall -y mysql-workbench-community-6.1.6-1.el6.x86_64.rpm

echo "Installing Vagrant"
cd /home/$USERNAME/Downloads/clean_install
yum --nogpgcheck localinstall -y vagrant_1.6.1_x86_64.rpm


echo "Installing Sublime Text 3"
cp -Rf sublime_text_3 /opt
chmod 777 /opt sublime_text_3
cp applications/sublime_text.desktop /usr/share/applications
echo "Sublime Text 3 now available in 'Programming' Section of Applications menu"

echo "Installing GIT Version Control"
yum -y install git

echo "Creating Java Development Environment (Eclipse) including Android Debugging and Decompiling"
mkdir /home/$USERNAME/dev
mv adt-bundle-linux-x86_64-20140321.zip /home/$USERNAME/dev
mv APK-Multi-Tool-master.zip /home/$USERNAME/dev
mv dex2jar-0.0.9.15.zip /home/$USERNAME/dev
mv jd-gui.tar.gz /home/$USERNAME/dev

cd /home/$USERNAME/dev
unzip adt-bundle-linux-x86_64-20140321.zip
mv adt-bundle-linux-x86_64-20140321 and
rm adt*

unzip APK-Multi-Tool-Linux-master.zip
mv APK-Multi-Tool-Linux-master apk_tool
mv apk_tool /home/$USERNAME/dev/and/sdk

mkdir jdgui
mv jd-gui.tar.gz jdgui
cd jdgui
tar -xvf jd-gui.tar.gz
rm jd-gui.tar.gz
cd ../
mv jdgui /home/$USERNAME/dev/and/sdk/tools

unzip dex2jar-0.0.9.15.zip
mv dex2jar-0.0.9.15 dex2jar
mv dex2jar /home/$USERNAME/dev/and/sdk/tools
cp /home/$USERNAME/dev/and/sdk/platform-tools/adb /home/$USERNAME/dev/and/sdk/apk_tools/other

cd /home/$USERNAME/dev/and/sdk/apk_tools
chmod -Rf +x other
chmod +x *.sh

echo "PATH=\$PATH: /home/\$USERNAME/dev/and/sdk/apk_tools" >> /home/$USERNAME/.bashrc
echo "export PATH" >> /home/$USERNAME/.bashrc

cd /home/$USERNAME/Downloads/clean_install

echo "export AAPT_HOME=/home/ciaran/dev/and/sdk/apk_tools/other" >>/usr/bin/aapt

echo "\$AAPT_HOME/a	apt \$*" >> /usr/bin/aapt

echo "export ADB_HOME=/home/ciaran/dev/and/sdk/apk_tools/other" >> /usr/bin/adb

echo "\$ADB_HOME/adb \$*" >> /usr/bin/adb

chmod +x /usr/bin/adb

chmod +x /usr/bin/aapt


echo "Installing Google Chrome"
chmod +x clean_install/install_chrome.sh

sh install_chrome.sh -f

echo "Remove Defunct Applications"
yum remove firefox thunderbird

echo "Install Email Client"
yum install --nogpgcheck -y evolution

echo "Installing VirtualBox - Ignore Warnings about rebuilding kernel for now"
yum --nogpgcheck localinstall -y VirtualBox-4.3-4.3.12_93733_el6-1.x86_64.rpm
VBoxManage extpack install Oracle_VM_VirtualBox_Extension_Pack-4.3.12-93733.vbox-extpack

echo "Rebooting. Once machine is back online please run the \"rebuild_virtualbox.sh\" script on the desktop as \"sudo\" or Root (After the updated Kernel has been loaded)"
echo "/etc/init.d/vboxdrv setup" >> /home/$USERNAME/Desktop/rebuild_virtualbox.sh
echo "Add Oracle Repos" >> /home/$USERNAME/Desktop/rebuild_virtualbox.sh
echo "cd /etc/yum.repos.d" >> /home/$USERNAME/Desktop/rebuild_virtualbox.sh
echo "wget http://public-yum.oracle.com/public-yum-ol6.repo" >> /home/$USERNAME/Desktop/rebuild_virtualbox.sh
echo "wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | rpm --import oracle_vbox.asc" >> /home/$USERNAME/Desktop/rebuild_virtualbox.sh
echo "yum clean all" >> /home/$USERNAME/Desktop/rebuild_virtualbox.sh
cd /home/$USERNAME/Desktop/
chmod +x rebuild_virtualbox.sh
reboot
