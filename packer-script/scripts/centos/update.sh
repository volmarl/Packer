#!/bin/bash -eux

echo "Running yum update"
yum update -y
yum install yum-utils -y
package-cleanup --oldkernels --count=1 -y

ifup eth0
rpm -Uvh http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
yum -y install dkms binutils gcc make patch libgomp glibc-headers glibc-devel cpp kernel-devel kernel-headers perl openssh-clients man git vim wget curl ntp
#export KERN_DIR=/usr/src/kernels/`uname -r`

chkconfig ntpd on
service ntpd stop
ntpdate time.nist.gov
service ntpd start
chkconfig sshd on
chkconfig iptables off
chkconfig ip6tables off
sed -i -e 's/^SELINUX=.*/SELINUX=permissive/' /etc/selinux/config
sed -i -e 's/^UUID=.*//' /etc/sysconfig/network-scripts/ifcfg-eth0
sed -i -e 's/^HWADDR=.*//' /etc/sysconfig/network-scripts/ifcfg-eth0
rm -f /etc/udev/rules.d/70-persistent-net.rules

echo "Rebooting"
reboot

echo "Sleeping to prevent packer from running the next script"
sleep 20
