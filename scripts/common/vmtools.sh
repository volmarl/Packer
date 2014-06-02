#!/bin/bash

if type yum >/dev/null 2>&1; then

ifup eth0
rpm -Uvh http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
yum -y install dkms binutils gcc make patch libgomp glibc-headers glibc-devel cpp kernel-devel kernel-headers perl openssh-clients man git vim wget curl ntp
sudo yum install yum-utils -y
yum -y update
package-cleanup --oldkernels --count=1 -y
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


fi


case "$PACKER_BUILDER_TYPE" in 

virtualbox-iso|virtualbox-ovf) 
    mkdir /tmp/vbox
    VER=$(cat /home/vagrant/.vbox_version)
    mount -o loop /home/vagrant/VBoxGuestAdditions_$VER.iso /tmp/vbox 
    sh /tmp/vbox/VBoxLinuxAdditions.run
    sudo /etc/init.d/vboxadd setup
    umount /tmp/vbox
    rmdir /tmp/vbox
    rm /home/vagrant/*.iso
    sudo ln -s /opt/VBoxGuestAdditions-4.3.10/lib/VBoxGuestAdditions /usr/lib/VBoxGuestAdditions
    ;;

vmware-iso|vmware-ovf) 
    mkdir /tmp/vmfusion
    mkdir /tmp/vmfusion-archive
    mount -o loop /home/vagrant/linux.iso /tmp/vmfusion
    tar xzf /tmp/vmfusion/VMwareTools-*.tar.gz -C /tmp/vmfusion-archive
    /tmp/vmfusion-archive/vmware-tools-distrib/vmware-install.pl --default
    umount /tmp/vmfusion
    rm -rf  /tmp/vmfusion
    rm -rf  /tmp/vmfusion-archive
    #rm /home/vagrant/*.iso
    ;;

*)
    echo "Unknown Packer Builder Type >>$PACKER_BUILDER_TYPE<< selected."
    echo "Known are virtualbox-iso|virtualbox-ovf|vmware-iso|vmware-ovf."
    ;;

esac
