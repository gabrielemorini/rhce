#!/bin/bash
# RHCE Complete Validation Report Generator
# Validates all RHCE exam tasks

USER=$(whoami)
REPORT_FILE="/home/${USER}/ansible/tests/rhce_validation_report.txt"
DATE=$(date '+%Y-%m-%d %H:%M:%S')
VAULT_PASS_FILE="/home/${USER}/ansible/password.txt"
ANSIBLE_CONFIG="/home/${USER}/ansible/ansible.cfg"
ANSIBLE_BASE_DIR="/home/${USER}/ansible"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print status
print_status() {
    local status=$1
    local message=$2
    if [ "$status" = "PASS" ]; then
        echo -e "${GREEN}[PASS]${NC} $message"
        echo "[PASS] $message" >> $REPORT_FILE
    elif [ "$status" = "FAIL" ]; then
        echo -e "${RED}[FAIL]${NC} $message"
        echo "[FAIL] $message" >> $REPORT_FILE
    else
        echo -e "${YELLOW}[INFO]${NC} $message"
        echo "[INFO] $message" >> $REPORT_FILE
    fi
}

# Initialize report
echo "=== RHCE COMPLETE VALIDATION REPORT ===" > $REPORT_FILE
echo "Generated: $DATE" >> $REPORT_FILE
echo "Validation Script for all 18 RHCE Tasks" >> $REPORT_FILE
echo "==========================================" >> $REPORT_FILE

print_status "INFO" "Starting RHCE validation..."

# Task 1: Ansible Installation & Configuration
echo "" >> $REPORT_FILE
echo "TASK 1: ANSIBLE INSTALLATION & CONFIGURATION" >> $REPORT_FILE
echo "=============================================" >> $REPORT_FILE

print_status "INFO" "Validating Task 1: Ansible Installation & Configuration"

# Check ansible installation
if command -v ansible >/dev/null 2>&1; then
    print_status "PASS" "Ansible is installed"
    ansible --version >> $REPORT_FILE 2>&1
else
    print_status "FAIL" "Ansible is not installed"
fi

# Check ansible.cfg
if [ -f "$ANSIBLE_CONFIG" ]; then
    print_status "PASS" "ansible.cfg exists"
    echo "ansible.cfg content:" >> $REPORT_FILE
    cat $ANSIBLE_CONFIG >> $REPORT_FILE 2>&1
else
    print_status "FAIL" "ansible.cfg not found"
fi

# Check inventory file
if [ -f "${ANSIBLE_BASE_DIR}/inventory/hosts" ]; then
    print_status "PASS" "Inventory file exists"
    echo "Inventory content:" >> $REPORT_FILE
    cat ${ANSIBLE_BASE_DIR}/inventory >> $REPORT_FILE 2>&1
else
    print_status "FAIL" "Inventory file not found"
fi

# Verify inventory groups
echo "Inventory verification:" >> $REPORT_FILE
ansible-inventory --graph >> $REPORT_FILE 2>&1

# Connectivity test
echo "" >> $REPORT_FILE
echo "FINAL CONNECTIVITY TEST" >> $REPORT_FILE
echo "========================" >> $REPORT_FILE

print_status "INFO" "Running connectivity test"
ansible all -m ping >> $REPORT_FILE 2>&1

# Task 2: YUM Repository Setup
echo "" >> $REPORT_FILE
echo "TASK 2: YUM REPOSITORY SETUP" >> $REPORT_FILE
echo "============================" >> $REPORT_FILE

print_status "INFO" "Validating Task 2: YUM Repository Setup"

# Check if yum-repo.sh script exists
if [ -f "${ANSIBLE_BASE_DIR}/scripts/yum-repo.sh" ]; then
    print_status "PASS" "yum_repo.sh script exists"
    echo "yum-repo.sh content:" >> $REPORT_FILE
    cat ${ANSIBLE_BASE_DIR}/scripts/yum_repo.sh >> $REPORT_FILE 2>&1
else
    print_status "FAIL" "yum_repo.sh script not found"
fi

# Verify repositories on managed nodes
echo "Repository verification on managed nodes:" >> $REPORT_FILE
ansible all -m shell -a "yum repolist | grep -E '(BaseOS|AppStream)'" >> $REPORT_FILE 2>&1

# Task 3: Package Management
echo "" >> $REPORT_FILE
echo "TASK 3: PACKAGE MANAGEMENT" >> $REPORT_FILE
echo "==========================" >> $REPORT_FILE

print_status "INFO" "Validating Task 3: Package Management"

# Check packages.yml syntax
if ansible-playbook --syntax-check playbooks/packages.yml >/dev/null 2>&1; then
    print_status "PASS" "packages.yml syntax is valid"
else
    print_status "FAIL" "packages.yml syntax error"
fi

# Verify packages installation
echo "Package verification:" >> $REPORT_FILE
ansible dev,test,prod -m shell -a 'printf "\n==== %s ====\n" "$(hostname -s)"; rpm -qa | grep -E "(php|mariadb)"' >> $REPORT_FILE 2>&1
ansible dev -m shell -a "yum grouplist installed | grep 'Development Tools'" >> $REPORT_FILE 2>&1

# Task 4: Time Synchronization
echo "" >> $REPORT_FILE
echo "TASK 4: TIME SYNCHRONIZATION" >> $REPORT_FILE
echo "============================" >> $REPORT_FILE

print_status "INFO" "Validating Task 4: Time Synchronization"

# Check timesync.yml syntax
if ansible-playbook --syntax-check playbooks/timesync.yml >/dev/null 2>&1; then
    print_status "PASS" "timesync.yml syntax is valid"
else
    print_status "FAIL" "timesync.yml syntax error"
fi

# Verify time synchronization
echo "Time synchronization status:" >> $REPORT_FILE
ansible all -m command -a 'printf "\n==== %s ====\n" "$(hostname -s)"; timedatectl status' >> $REPORT_FILE 2>&1
ansible all -m shell -a "chrony sources -v | grep 172.25.254.250" >> $REPORT_FILE 2>&1

# Task 5: Apache Role
echo "" >> $REPORT_FILE
echo "TASK 5: APACHE ROLE" >> $REPORT_FILE
echo "==================" >> $REPORT_FILE

print_status "INFO" "Validating Task 5: Apache Role"

# Check apache role structure
if [ -d "${ANSIBLE_BASE_DIR}/roles/apache" ]; then
    print_status "PASS" "Apache role directory exists"
    echo "Apache role structure:" >> $REPORT_FILE
    find ${ANSIBLE_BASE_DIR}/roles/apache -type f >> $REPORT_FILE 2>&1
else
    print_status "FAIL" "Apache role directory not found"
fi

# Verify Apache service and firewall
echo "Apache service verification:" >> $REPORT_FILE
ansible all -m command -a "systemctl is-active httpd" >> $REPORT_FILE 2>&1
ansible all -m shell -a "firewall-cmd --list-services | grep http" >> $REPORT_FILE 2>&1

# Check index.html template
echo "Index.html content verification:" >> $REPORT_FILE
ansible all -m shell -a "curl -s http://localhost/ | head -3" >> $REPORT_FILE 2>&1

# Task 6: Ansible Galaxy Roles
echo "" >> $REPORT_FILE
echo "TASK 6: ANSIBLE GALAXY ROLES" >> $REPORT_FILE
echo "============================" >> $REPORT_FILE

print_status "INFO" "Validating Task 6: Ansible Galaxy Roles"

# Check requirements.yml
if [ -f "${ANSIBLE_BASE_DIR}/roles/requirements.yml" ]; then
    print_status "PASS" "requirements.yml exists"
    echo "requirements.yml content:" >> $REPORT_FILE
    cat ${ANSIBLE_BASE_DIR}/roles/requirements.yml >> $REPORT_FILE 2>&1
else
    print_status "FAIL" "requirements.yml not found"
fi

# Verify installed roles
echo "Installed Galaxy roles:" >> $REPORT_FILE
ansible-galaxy list >> $REPORT_FILE 2>&1

# Task 7: Squid Playbook
echo "" >> $REPORT_FILE
echo "TASK 7: SQUID PLAYBOOK" >> $REPORT_FILE
echo "=====================" >> $REPORT_FILE

print_status "INFO" "Validating Task 7: Squid Playbook"

# Check squid_proxy.yml syntax
if ansible-playbook --syntax-check playbooks/squid_proxy.yml >/dev/null 2>&1; then
    print_status "PASS" "squid_proxy.yml syntax is valid"
else
    print_status "FAIL" "squid_proxy.yml syntax error"
fi

# Check proxy functionality on node03(dev) - Should be allowed!
ansible node03 -m shell -a "curl -I --proxy node05:3128 http://google.com" >> $REPORT_FILE
# Check proxy functionality on node02(test) - Should be blocked!
ansible node02 -m shell -a "curl -I --proxy node05:3128 http://google.com" >> $REPORT_FILE

# Task 8: Test Environment Setup
echo "" >> $REPORT_FILE
echo "TASK 8: TEST ENVIRONMENT SETUP" >> $REPORT_FILE
echo "==============================" >> $REPORT_FILE

print_status "INFO" "Validating Task 8: Test Environment Setup"

# Check test.yml syntax
if ansible-playbook --syntax-check playbooks/test.yml >/dev/null 2>&1; then
    print_status "PASS" "test.yml syntax is valid"
else
    print_status "FAIL" "test.yml syntax error"
fi

# Verify /webtest directory and permissions
echo "/webtest directory verification:" >> $REPORT_FILE
ansible test -m shell -a "ls -ld /webtest" >> $REPORT_FILE 2>&1
ansible test -m shell -a "cat /webtest/index.html" >> $REPORT_FILE 2>&1

# Verify symbolic link
echo "Symbolic link verification:" >> $REPORT_FILE
ansible test -m command -a "ls -l /webtest " >> $REPORT_FILE 2>&1

# Task 9: Ansible Vault Creation
echo "" >> $REPORT_FILE
echo "TASK 9: ANSIBLE VAULT CREATION" >> $REPORT_FILE
echo "==============================" >> $REPORT_FILE

print_status "INFO" "Validating Task 9: Ansible Vault Creation"

# Check vault.yml exists
if [ -f "${ANSIBLE_BASE_DIR}/vars/vault.yml" ]; then
    print_status "PASS" "vault.yml exists"
else
    print_status "FAIL" "vault.yml not found"
fi

# Test vault accessibility
echo "Vault content verification:" >> $REPORT_FILE
if [ -f "$VAULT_PASS_FILE" ] && [ -f "${ANSIBLE_BASE_DIR}/vars/vault.yml" ]; then
    ansible-vault view "${ANSIBLE_BASE_DIR}/vars/vault.yml" --vault-password-file $VAULT_PASS_FILE >> $REPORT_FILE 2>&1
fi

# Task 10: Hosts File Generation
echo "" >> $REPORT_FILE
echo "TASK 10: HOSTS FILE GENERATION" >> $REPORT_FILE
echo "==============================" >> $REPORT_FILE

print_status "INFO" "Validating Task 10: Hosts File Generation"

# Check myhosts.j2 template
if [ -f "${ANSIBLE_BASE_DIR}/templates/myhosts.j2" ]; then
    print_status "PASS" "myhosts.j2 template exists"
    echo "myhosts.j2 content:" >> $REPORT_FILE
    cat ${ANSIBLE_BASE_DIR}/templates/myhosts.j2 >> $REPORT_FILE 2>&1
else
    print_status "FAIL" "myhosts.j2 template not found"
fi

# Check gen_hosts.yml syntax
if ansible-playbook --syntax-check playbooks/gen_hosts.yml >/dev/null 2>&1; then
    print_status "PASS" "gen_hosts.yml syntax is valid"
else
    print_status "FAIL" "gen_hosts.yml syntax error"
fi

# Verify /etc/myhosts generation
echo "/etc/myhosts verification:" >> $REPORT_FILE
ansible dev -m stat -a "path=/etc/myhosts" >> $REPORT_FILE 2>&1
ansible dev -m shell -a "cat /etc/myhosts | head -10" >> $REPORT_FILE 2>&1

# Task 11: Hardware Report
echo "" >> $REPORT_FILE
echo "TASK 11: HARDWARE REPORT" >> $REPORT_FILE
echo "========================" >> $REPORT_FILE

print_status "INFO" "Validating Task 11: Hardware Report"

# Check hwreport.yml syntax
if ansible-playbook --syntax-check playbooks/hwreport.yml >/dev/null 2>&1; then
    print_status "PASS" "hwreport.yml syntax is valid"
else
    print_status "FAIL" "hwreport.yml syntax error"
fi

# Verify hardware reports
echo "Hardware report verification:" >> $REPORT_FILE
ansible all -m stat -a "path=/root/hwreport.txt" >> $REPORT_FILE 2>&1
ansible all -m shell -a "head -5 /root/hwreport.txt" >> $REPORT_FILE 2>&1

# Task 12: Issue File Configuration
echo "" >> $REPORT_FILE
echo "TASK 12: ISSUE FILE CONFIGURATION" >> $REPORT_FILE
echo "=================================" >> $REPORT_FILE

print_status "INFO" "Validating Task 12: Issue File Configuration"

# Check issue.yml syntax
if ansible-playbook --syntax-check playbooks/issue.yml >/dev/null 2>&1; then
    print_status "PASS" "issue.yml syntax is valid"
else
    print_status "FAIL" "issue.yml syntax error"
fi

# Verify /etc/issue content
echo "/etc/issue content verification:" >> $REPORT_FILE
ansible dev -m shell -a "cat /etc/issue | grep Development" >> $REPORT_FILE 2>&1
ansible test -m shell -a "cat /etc/issue | grep Test" >> $REPORT_FILE 2>&1
ansible prod -m shell -a "cat /etc/issue | grep Production" >> $REPORT_FILE 2>&1


# Task 14: User Creation
echo "" >> $REPORT_FILE
echo "TASK 14: USER CREATION" >> $REPORT_FILE
echo "=====================" >> $REPORT_FILE

print_status "INFO" "Validating Task 14: User Creation"

# Check users_list.yml
if [ -f "${ANSIBLE_BASE_DIR}/vars/users_list.yml" ]; then
    print_status "PASS" "users_list.yml exists"
    echo "users_list.yml content:" >> $REPORT_FILE
    cat ${ANSIBLE_BASE_DIR}/vars/users_list.yml >> $REPORT_FILE 2>&1
else
    print_status "FAIL" "users_list.yml not found"
fi

# Check create_users.yml syntax
if ansible-playbook --syntax-check playbooks/create_users.yml --vault-password-file=vars/password.txt >/dev/null 2>&1; then
    print_status "PASS" "create_users.yml syntax is valid"
else
    print_status "FAIL" "create_users.yml syntax error"
fi

# Verify users creation
echo "User verification:" >> $REPORT_FILE
ansible dev:test -m shell -a "id adam 2>/dev/null || echo 'adam not found'" >> $REPORT_FILE 2>&1
ansible prod -m shell -a "id gabriel 2>/dev/null || echo 'gabriel not found'" >> $REPORT_FILE 2>&1
ansible dev:test -m shell -a "id lucifer 2>/dev/null || echo 'lucifer not found'" >> $REPORT_FILE 2>&1
ansible dev:test -m shell -a "id eva 2>/dev/null || echo 'eva not found'" >> $REPORT_FILE 2>&1


# Verify group membership
echo "Group membership verification:" >> $REPORT_FILE
ansible dev:test -m shell -a "groups adam 2>/dev/null | grep devops || echo 'adam not in devops'" >> $REPORT_FILE 2>&1
ansible dev:test -m shell -a "groups lucifer 2>/dev/null | grep devops || echo 'lucifer not in devops'" >> $REPORT_FILE 2>&1
ansible prod -m shell -a "groups gabriel 2>/dev/null | grep opsmgr || echo 'gabriel not in opsmgr'" >> $REPORT_FILE 2>&1
ansible prod -m shell -a "groups eva 2>/dev/null | grep opsmgr || echo 'eva not in opsmgr'" >> $REPORT_FILE 2>&1

# Task 15: Cron Jobs
echo "" >> $REPORT_FILE
echo "TASK 15: CRON JOBS" >> $REPORT_FILE
echo "=================" >> $REPORT_FILE

print_status "INFO" "Validating Task 15: Cron Jobs"

# Check cron.yml syntax
if ansible-playbook --syntax-check playbooks/cron.yml >/dev/null 2>&1; then
    print_status "PASS" "cron.yml syntax is valid"
else
    print_status "FAIL" "cron.yml syntax error"
fi

# Verify cron jobs
echo "Cron job verification:" >> $REPORT_FILE
ansible all -m shell -a "crontab -l -u natasha 2>/dev/null || echo 'No crontab for natasha'" >> $REPORT_FILE 2>&1

# Task 16: Logical Volume Management
echo "" >> $REPORT_FILE
echo "TASK 16: LOGICAL VOLUME MANAGEMENT" >> $REPORT_FILE
echo "==================================" >> $REPORT_FILE

print_status "INFO" "Validating Task 16: Logical Volume Management"

# Check lvm.yml syntax
if ansible-playbook --syntax-check playbooks/lvm.yml >/dev/null 2>&1; then
    print_status "PASS" "lvm.yml syntax is valid"
else
    print_status "FAIL" "lvm.yml syntax error"
fi

# Check partition.yml syntax
if ansible-playbook --syntax-check playbooks/partitions.yml >/dev/null 2>&1; then
    print_status "PASS" "partitions.yml syntax is valid"
else
    print_status "FAIL" "partitions.yml syntax error"
fi

# Verify logical volumes
echo "Logical volume verification:" >> $REPORT_FILE
ansible all -m shell -a "lvs 2>/dev/null | grep data || echo 'No data LV found'" >> $REPORT_FILE 2>&1
ansible all -m shell -a "vgs 2>/dev/null | grep research || echo 'No research VG found'" >> $REPORT_FILE 2>&1

# Verify partitions and mounts
echo "Partition and mount verification:" >> $REPORT_FILE
ansible prod -m shell -a "mount | grep /srv || echo 'No /srv mount found'" >> $REPORT_FILE 2>&1
ansible all -m shell -a "lsblk | grep sdb || echo 'No sdb disk found'" >> $REPORT_FILE 2>&1

# Task 17: (Task 18 in original) SELinux Configuration
echo "" >> $REPORT_FILE
echo "TASK 17-18: SELINUX CONFIGURATION" >> $REPORT_FILE
echo "=================================" >> $REPORT_FILE

print_status "INFO" "Validating Task 17-18: SELinux Configuration"

# Check selinux.yml syntax
if ansible-playbook --syntax-check playbooks/selinux.yml >/dev/null 2>&1; then
    print_status "PASS" "selinux.yml syntax is valid"
else
    print_status "FAIL" "selinux.yml syntax error"
fi

# Check selinux2.yml syntax
if ansible-playbook --syntax-check playbooks/selinux2.yml >/dev/null 2>&1; then
    print_status "PASS" "selinux2.yml syntax is valid"
else
    print_status "FAIL" "selinux2.yml syntax error"
fi

# Verify SELinux status
echo "SELinux status verification:" >> $REPORT_FILE
ansible all -m command -a "getenforce" >> $REPORT_FILE 2>&1
ansible all -m shell -a "grep '^SELINUX=' /etc/selinux/config" >> $REPORT_FILE 2>&1


# Summary
echo "" >> $REPORT_FILE
echo "VALIDATION SUMMARY" >> $REPORT_FILE
echo "==================" >> $REPORT_FILE

# Count results
PASS_COUNT=$(grep "\\[PASS\\]" $REPORT_FILE | wc -l)
FAIL_COUNT=$(grep "\\[FAIL\\]" $REPORT_FILE | wc -l)
TOTAL_CHECKS=$((PASS_COUNT + FAIL_COUNT))

echo "Total Checks: $TOTAL_CHECKS" >> $REPORT_FILE
echo "Passed: $PASS_COUNT" >> $REPORT_FILE
echo "Failed: $FAIL_COUNT" >> $REPORT_FILE
echo "Success Rate: $(($PASS_COUNT * 100 / $TOTAL_CHECKS))%" >> $REPORT_FILE

print_status "INFO" "Validation completed!"
print_status "INFO" "Total Checks: $TOTAL_CHECKS | Passed: $PASS_COUNT | Failed: $FAIL_COUNT"
print_status "INFO" "Success Rate: $(($PASS_COUNT * 100 / $TOTAL_CHECKS))%"
print_status "INFO" "Detailed report saved to: $REPORT_FILE"

echo ""
echo "========================================"
echo "Run this script with: bash validate_rhce.sh"
echo "Review the full report: cat $REPORT_FILE"
echo "========================================"