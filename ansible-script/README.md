
Grid - Ansible Project: Push-Button Deploy feature.

The end result of this (currently) is to deploy a fully configured Aerospike cluster.  Going forward it will be easy to add on a AMC instance, clients, YCSB load testing cluster (partially implemented).

Below is the UI.  Picture the sideways ‘A’ mixed in with Cassandra and Riak. 




Once the product is selected the cluster topology options are divided into two different profiles with the fixed labels ‘Production’ and ‘Development’.  The image below shows the production profile for riak.  Production deployments include a security-group managed cloud firewall that is off by default for the development profile.




These are usually synonymous with big and small deployments.  For riak development is a 3 node cluster and production is 5.  For Aerospike (for the time being) we have elected the following profile setting:

Development
Cluster size: 4
Machine flavor: RAW (bare metal) 16 core, 32G DRAM, 40G Storage
Platform: Ubuntu v14.04

Production
Cluster size: 4
Machine flavor: same
Platform: same

To enable this GoGrid has an internal orchestration service based on Ansible (www.ansible.com) which takes the profile specification above along with our deployment script (‘playbook’ in Ansible speak).  

The current process of developing and submitting these deployment scripts has no automation.  We explain what inventory we want and provide them our ansible playbook (and the icon they will use in the UI).  GoGrid will review and validate our script through their QA process and barring any bugs the feature will go live within a week.

So, how do we develop the playbook? 
First install Ansible on a GoGrid instance. It doesn’t need to be very beefy, ansible delegates work to the cluster nodes.  GoGrid currently supports Ansible v1.5.5 but they will soon support v1.7.  Use: pip install ansible==1.5.5.
Next deploy all the instances you will need for your Aerospike cluster.  Write down the public and private ip address and the login passwords for reference. The login will always be root.
Write an ‘inventory file’. Using the ini file format (en.wikipedia.org/wiki/INI_file) list all the ip addresses and specify any group relationships like YCSB nodes, server nodes, AMC node, etc.  GoGrid requires one group named ‘servers’ containing all nodes.  I added an additional group called ‘db-servers’.  If you need to destroy or add a new instance update this file to use it in the ansible deployment.
In order for Ansible to talk to each of the servers in the inventory file you need to create an ssh keypair using ssh-keygen on your ansible box.  Then use something like ssh-copy-id to enable passwordless login to the servers in the inventory file. 
Note: During the real push-button deploy a key will be distributed the same way and then deleted after after the script finishes as a post process. If nodes need to be able to communicate with each other you have to enable that yourself in the script.

Now you have the environment prepared to start developing your playbook.  Lets define some Ansible concepts to understand what’s going on here.  First all ancible scripts are written in YAML (except the inventory file) in a directory hierarchy rooted in a folder named playbooks.

playbooks/
  make_aerospike_cluster.yml
  roles/
     aerospike/              ← vendor
        aerospike/           ← role name
           tasks/
              main.yml
           handlers/          ← tasks triggered conditionally 
              main.yml
           vars/
              main.yml
           templates/        ← template engine is called jinja2
              aerospike.conf.j2
     common/               ← GoGrid provided scripts 
        pre/
        post/

Playbook: This is the top-level script (make_aerospike_cluster.yml).  Each stanza of this script is called a play.  

Play: Each play runs a script on a group of hosts in parallel.  For aerospike it’s simple; we have one group of server hosts and we script the install and configuration of the aerospike.conf.  

Before starting this script you can ‘gather facts’ about each of the hosts into a common context object called hostvars visible to each instance for the remainder of the playbook. For this reason we gather facts in the first play from all instances.  Additionally at that time we need to run some setup tasks provided by GoGrid, this is common/pre/main.yml.

Role: This is basically a namespace for your script. Within the role the main script is tasks/main.yml.  You would create a different role to configure an AMC instance for example, aerospike/amc instead of aerospike/aerospike.

Task: This is the linear sequence of steps that run on each host.  Each step is identified by a name and a ansible module.  The module reference is here http://docs.ansible.com/list_of_all_modules.html.  The most important are shell and template.  

For the make_aerospike_cluster.yml playbook the following steps are implemented:
create directory /tmp/staging
install curl
download server tarball to staging
extract and install (ignoring errors if already installed)
configure /etc/aerospike/aerospike.conf
template based on default 3.2.9 config file
service.service-threads {{ vcpus }}
service.transaction-queues {{ vcpus }}    ← vcpu - 1 seems to be faster
network.service.access-address {{ external_ip }}
mode mesh & mesh-address {{next ip in server list mod list size (ring topology) }}
network.heartbeat.interval 250   ← 150 on current 
network.heartbeat.timeout 50     ← 10 on current
memory-size {{ total available ram }}
bar namespace deleted
if after all these changes the file is different bounce the server if already started
start aerospike if not already started (first run)


YCSB Setup

I created a make_ycsb_cluster.yml ansible script as well but it wasn’t completed in time to be ready for the demo.  If you want to use it feel free to ask me any questions.

