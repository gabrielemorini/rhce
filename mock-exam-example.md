## **1\. Install and configure Ansible on the control node:**

a) Install the required packages. 

b) Create a static inventory file called /home/gabriele/ansible/inventory so that:   
\- node1 is a member of the dev host group.   
\- node2 is a member of the test host group.   
\- node3 and node4 are the members of the prod host group.   
\- node5 is a member of the balancers host group.   
\- The prod group is a member of the webservers host group. 

c) Create a configuration file called /home/gabriele/ansible/ansible.cfg so that:   
\- The host inventory file is /home/gabriele/ansible/inventory   
\- The default content collections directory is /home/gabriele/ansible/mycollection   
\- The default roles directory is /home/gabriele/ansible/roles

<details>
<summary><strong>Solution</strong></summary>

</details>



## **2\. Create and run an Ansible ad-hoc command. As a system administrator, you will need to install software on the managed nodes:**

a) Create a shell script called yum-repo.sh that runs Ansible ad-hoc commands to create the yum repositories on each of the managed nodes as per the following details:   
b) you need to create 2 repos (BaseOS & AppStream) in the managed nodes.
c) Create the yum-repo.yml playbook to set up YUM repositories. Choose whether to use a shell script or an Ansible playbook for the installation.
**NOTE:** If you're testing locally, I recommend removing the GPG key and setting gpgcheck=no (which disables GPG signature verification).

**BaseOS:**

* name: BaseOS  
* baseurl: file:///mnt/BaseOS/  
* description: Base OS Repo  
* gpgcheck: yes  
* enabled: yes  
* key: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release

**AppStream:**

* name: AppStream  
* baseurl: file:///mnt/AppStream/  
* description: AppStream Repo  
* gpgcheck: yes  
* enabled: yes  
* key: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release

<details>
<summary><strong>Solution</strong></summary>

</details>

## **3\. Create a playbook called /home/gabriele/ansible/packages.yml that:**

a) Installs the php and mariadb packages on hosts in the dev, test, and prod host groups only.   
b) Installs the RPM Development Tools package group on hosts in the dev host group only. 
c) Updates all packages to the latest version on hosts in the dev host group only.

<details>
<summary><strong>Solution</strong></summary>

</details>

## **4\. Install the RHEL system roles package and create a playbook called /home/gabriele/ansible/timesync.yml that:**

a) Runs on all the managed hosts.   
b) Uses the timesync role.  
c) Configures the role to use the time server 172.25.254.250   
d) Configures the role to set the iburst parameter as enabled.

<details>
<summary><strong>Solution</strong></summary>

</details>

## **5\. Create a role called apache in /home/gabriele/ansible/roles with the following requirements:**

a) The httpd package should be installed, httpd service should be enabled on boot, and started.   
b) The firewall is enabled and running with a rule to allow access to the web server.   
c) Create file index.html.j2 and used it to create the file /var/www/html/index.html with the following output: 

*Welcome to HOSTNAME on IPADDRESS, where HOSTNAME is the fully qualified domain name of the managed node and IPADDRESS is the IP address of the managed node.*

<details>
<summary><strong>Solution</strong></summary>

</details>

## **6\. Use Ansible Galaxy with the requirements file called /home/gabriele/ansible/roles/requirements.yml and install roles to /home/gabriele/ansible/roles from the following URLs:**

a) https://galaxy.ansible.com/download/zabbix-zabbix-1.0.6.tar.gz   
The name of this role should be zabbix. 

b) https://galaxy.ansible.com/download/openafs\_contrib-openafs-1.9.0.tar.gz   
The name of this role should be security. 

c) https://galaxy.ansible.com/download/mafalb-squid-0.2.0.tar.gz   
The name of this role should be squid.

## **7\. Create a playbook called squid.yml as per the following details:**

a) The playbook contains a play that runs on hosts in the balancers host group and uses the squid role present in your machine.

## **8\. Create a playbook called test.yml as per the following details:**

a) The playbook runs on managed nodes in the test host group.   
b) Create the directory /webtest with the group ownership webtest group and having the regular permissions rwx for the owner and group and rx for the others.   
c) Apply the special permissions: set group ID   
d) Symbolically link /var/www/html/webtest to /webtest directory.   
e) Create the file /webtest/index.html with a single line of text that reads: Testing.

## **9\. Create an Ansible vault to store user passwords with the following conditions:**

a) The name of the vault is vault.yml   
b) The vault contains two variables, dev\_pass with value as redhat and mgr\_pass with value as linux respectively.   
c) The password to encrypt and decrypt the vault is gabriele  
d) The password is stored in the file /home/gabriele/ansible/password.txt file.

<details>
<summary><strong>Solution</strong></summary>

  ```bash
echo 'password=gabriele' > password.txt

ansible-vault create vault.yml --vault-password-file=password.txt
dev_pass: redhat
mgr_pass: linux
  ```
</details>


## **10\. Generate hosts files:**

a) Create the myhosts.j2 template so that it can be used to generate a file with a line for each inventory host in the same format as /etc/hosts. Move the myhosts.j2 template to the correct directory, if needed create it.

b) Create a playbook called gen\_hosts.yml that uses this template to generate the file /etc/myhosts on hosts in the dev host group. 

c) When completed, the file /etc/myhosts on hosts in the dev host group should have a line for each managed host:

127.0.0.1 localhost localhost.localdomain localhost4 localhost4.localdomain4  
::1 localhost localhost.localdomain localhost6 localhost6.localdomain6  
192.168.10.x node1.example.com node1  
192.168.10.y node2.example.com node2  
192.168.10.z node3.example.com node3  
192.168.10.a node4.example.com node4  
192.168.10.b node5.example.com node5

## **11\. Create a playbook called hwreport.yml that produces an output file called /root/hwreport.txt on all of the managed nodes with the following information:**

a) Inventory hostname   
b) Total memory in MB   
c) BIOS version 

Each line of the output file contains a single key-value pair.

##   **12\. Create a playbook called /home/gabriele/ansible/issue.yml as per the following requirements:**

a) The playbook runs on all inventory hosts.   
b) The playbook replaces the contents of /etc/issue with a single line of text as:   
- On hosts in the dev host group, the line reads: Development   
- On hosts in the test host group, the line reads: Test   
- On hosts in the prod host group, the line reads: Production

## **13\. Rekey an existing Ansible vault as per the following conditions:**

a) Use the vault.yml file which you have created earlier.   
b) Set the new vault password as gabdev.   
c) The vault remains in an encrypted state with the new password.

<details>
<summary><strong>Solution</strong></summary>

  ```bash
ansible-vault rekey vault.yml --vault-password-file=password.txt

echo 'password=gabdev' > password.txt
  ```
</details>

## **14\. Create user accounts.**   
**A list of users to be created can be found in the file called users\_list.yml save to /home/gabriele/ansible/vars directory.**   
**Using the password vault created elsewhere in this exam, create a playbook called create\_user.yml that creates user accounts as follows:**

a) Users with a job description of developer should be created on managed nodes in the dev and test host groups assigned the password from the dev\_pass variable and are members of supplementary group devops.   
b) Users with a job description of manager should be created on managed nodes in the prod host group assigned the password from the mgr\_pass variable and are members of supplementary group opsmgr.   
c) Passwords should use the SHA512 hash format. Your playbook should work using the vault password file created elsewhere in this exam.

## **15\. Configure cron jobs:**

Create /home/gabriele/ansible/cron.yml playbook as per the following requirements:   
a) This playbook runs on all managed nodes in the hostgroup.   
b) Configure cronjob, which runs every 2 minutes and executes the following commands: logger "EX294 exam in progress" and run as user natasha.

## **16\. Create and use a logical volume:**

Create a playbook called /home/gabriele/ansible/lvm.yml that runs on all the managed nodes and does the following:   
a) Creates a logical volume with the following requirements:   
\- The logical volume is created in the research volume group.   
\- The logical volume name is data.   
\- The logical volume size is 1200 Mib.   
\- Format the logical volume with the ext4 file-system.   
\- If the requested logical volume size cannot be created, the error message "could not create logical volume of that size" should be displayed and size 800 MiB should be used instead.   
\- If the volume research does not exist, the error message "volume group does not exist" should be displayed.   
\- Don't mount the logical volume in any way.

## **17\. Create a partition:**

Create /home/gabriele/ansible/partition.yml, which will create partitions on all the managed nodes: 

a) After sdb creating a 1200M primary partition, partition number 1, and format it into ext4 filesystem.   
b) On the prod group to permanently mount the partition to /srv directory.   
c) If there is not enough disk space, give prompt information "Could not create partition of that size" and create a 800M partition.   
d) If sdb does not exist, a prompt message will be given "this disk does not exist."

## **18\. Using a selinux role create a selinux.yml playbook with the following conditions:**

a) Configure on all managed hosts to set the default selinux mode as permissive.   
b) Verify the selinux mode on all the nodes using ansible ad-hoc command.   
c) Create another copy of the selinux.yml playbook with the name as selinux2.yml and make changes there in it to configure the selinux default mode as enforcing for all the managed nodes.   
d) Execute the selinux2.yml playbook using ansible navigator.   
e) Verify the selinux mode on all the node machines.
