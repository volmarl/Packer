# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
    config.vm.define "vagrant-as"
    config.vm.box = "aerospike-vm"
    config.vm.network "forwarded_port", guest: 3000, host: 3000 , auto_correct: true
    config.vm.network "forwarded_port", guest: 8081, host: 8081 , auto_correct: true 
    # Berkshelf
    # config.berkshelf.enabled = true
  
    # Shell - Hello World
    # config.vm.provision :shell, :inline => "C:\\vagrant\\scripts\\HelloWorld.bat"
  
    config.vm.provider :virtualbox do |v, override|
        v.gui = false
        v.customize ["modifyvm", :id, "--memory", 1536]
        v.customize ["modifyvm", :id, "--cpus", 2]
#        v.customize ["modifyvm", :id, "--vram", "256"]
#        v.customize ["setextradata", "global", "GUI/MaxGuestResolution", "any"]
#        v.customize ["setextradata", :id, "CustomVideoMode1", "1024x768x32"]
#        v.customize ["modifyvm", :id, "--ioapic", "on"]
#        v.customize ["modifyvm", :id, "--rtcuseutc", "on"]
#        v.customize ["modifyvm", :id, "--accelerate3d", "on"]
#        v.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
    end

    config.vm.provider :vmware_fusion do |v, override|
        v.gui = false
        v.vmx["memsize"] = "1536"
        v.vmx["numvcpus"] = "2"
        v.vmx["cpuid.coresPerSocket"] = "1"
#        v.vmx["ethernet0.virtualDev"] = "vmxnet3"
#        v.vmx["scsi0.virtualDev"] = "lsilogic"
    end

    config.vm.provider :vmware_workstation do |v, override|
        v.gui = false
        v.vmx["memsize"] = "1536"
        v.vmx["numvcpus"] = "2"
        v.vmx["cpuid.coresPerSocket"] = "1"
#        v.vmx["ethernet0.virtualDev"] = "vmxnet3"
#        v.vmx["scsi0.virtualDev"] = "lsilogic"
    end
end
