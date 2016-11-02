#!/bin/bash

if [ ! -f ./rhel.pem ]
then
	echo 'No rhel.pem file found!'
	exit
fi

yum install -y dbus-python libxml2-python m2crypto pyOpenSSL python-dmidecode python-ethtool python-gudev usermode python-dateutil python-rhsm python-hwdata python-kitchen system-logos

mkdir /tmp/rhel
cp ./rhel.pem /tmp/rhel/rhel.pem
cd /tmp/rhel
wget 'https://github.com/puteulanus/c2r/raw/master/rpms/yum-utils-1.1.31-34.el7.noarch.rpm'
wget 'https://github.com/puteulanus/c2r/raw/master/rpms/redhat-release-server-7.2-9.el7.x86_64.rpm'
wget 'https://github.com/puteulanus/c2r/raw/master/rpms/rhn-check-2.0.2-6.el7.noarch.rpm'
wget 'https://github.com/puteulanus/c2r/raw/master/rpms/rhn-client-tools-2.0.2-6.el7.noarch.rpm'
wget 'https://github.com/puteulanus/c2r/raw/master/rpms/rhn-setup-2.0.2-6.el7.noarch.rpm'
wget 'https://github.com/puteulanus/c2r/raw/master/rpms/rhnlib-2.5.65-2.el7.noarch.rpm'
wget 'https://github.com/puteulanus/c2r/raw/master/rpms/rhnsd-5.0.13-5.el7.x86_64.rpm'
wget 'https://github.com/puteulanus/c2r/raw/master/rpms/subscription-manager-1.15.9-15.el7.x86_64.rpm'
wget 'https://github.com/puteulanus/c2r/raw/master/rpms/yum-3.4.3-132.el7.noarch.rpm'
wget 'https://github.com/puteulanus/c2r/raw/master/rpms/yum-metadata-parser-1.1.4-10.el7.x86_64.rpm'
wget 'https://github.com/puteulanus/c2r/raw/master/rpms/yum-rhn-plugin-2.0.1-5.el7.noarch.rpm'
wget https://www.redhat.com/security/fd431d51.txt
rpm --import fd431d51.txt
rpm -e --nodeps centos-release
rpm -e centos-release-cr
rpm -qa centos\* redhat\* | xargs rpm -e
rpm -Uhv --force *.rpm
rpm -e yum-plugin-fastestmirror
yum clean all

subscription-manager import --certificate=./rhel.pem

yum update
rpm -qa --qf "%{NAME} %{VENDOR}\n" | grep CentOS | cut -d' ' -f1 | grep -v ^kernel | sort | tee lst
yum reinstall $(cat lst)
yum distro-sync
