#!/bin/bash

yum install -y wget dbus-python libxml2-python m2crypto pyOpenSSL python-dmidecode \
    python-ethtool python-gudev usermode python-dateutil python-rhsm python-hwdata \
    python-kitchen newt-python gobject-introspection pygobject3-base virt-what

mkdir /tmp/rhel
cd /tmp/rhel

wget 'https://github.com/puteulanus/c2r/raw/master/rpms/yum-utils-1.1.31-34.el7.noarch.rpm'
wget 'https://github.com/puteulanus/c2r/raw/master/rpms/rhn-check-2.0.2-6.el7.noarch.rpm'
wget 'https://github.com/puteulanus/c2r/raw/master/rpms/rhn-client-tools-2.0.2-6.el7.noarch.rpm'
wget 'https://github.com/puteulanus/c2r/raw/master/rpms/rhn-setup-2.0.2-6.el7.noarch.rpm'
wget 'https://github.com/puteulanus/c2r/raw/master/rpms/rhnlib-2.5.65-2.el7.noarch.rpm'
wget 'https://github.com/puteulanus/c2r/raw/master/rpms/rhnsd-5.0.13-5.el7.x86_64.rpm'
wget 'https://github.com/puteulanus/c2r/raw/master/rpms/yum-3.4.3-132.el7.noarch.rpm'
wget 'https://github.com/puteulanus/c2r/raw/master/rpms/yum-metadata-parser-1.1.4-10.el7.x86_64.rpm'
wget 'https://github.com/puteulanus/c2r/raw/master/rpms/yum-rhn-plugin-2.0.1-5.el7.noarch.rpm'

wget 'https://github.com/puteulanus/c2r/raw/master/rpms/subscription-manager-1.21.10-2.el7.x86_64.rpm'
wget 'https://github.com/puteulanus/c2r/raw/master/rpms/subscription-manager-rhsm-1.21.10-2.el7.x86_64.rpm'
wget 'https://github.com/puteulanus/c2r/raw/master/rpms/subscription-manager-rhsm-certificates-1.21.10-2.el7.x86_64.rpm'
wget 'https://github.com/puteulanus/c2r/raw/master/rpms/python-inotify-0.9.4-4.el7.noarch.rpm'
wget 'https://github.com/puteulanus/c2r/raw/master/rpms/redhat-release-server-7.6-4.el7.x86_64.rpm'

wget https://www.redhat.com/security/fd431d51.txt
rpm --import fd431d51.txt
rpm -e --nodeps centos-release
rpm -Uhv --force *.rpm
rpm -e yum-plugin-fastestmirror
yum clean all

subscription-manager register
subscription-manager attach --auto

yum update -y
rpm -qa --qf "%{NAME} %{VENDOR}\n" | grep CentOS | cut -d' ' -f1 | grep -v ^kernel | sort | tee lst
yum reinstall $(cat lst) -y
yum distro-sync -y
rpm -e --nodeps centos-logos
yum install -y system-logos

rpm -qa centos\*

subscription-manager repos --enable rhel-7-server-optional-rpms
subscription-manager repos --enable rhel-7-server-extras-rpms
subscription-manager repos --enable rhel-server-rhscl-7-rpms
