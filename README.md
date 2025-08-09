# RHCE 9 - Red Hat Certfied Engineer - Exam Simulation 

## 📋 Introduction

This repository contains my full implementation of the **RHCE (Red Hat Certified Engineer)** exam objectives. To dive right in, start with the [mock-exam-example.md](https://github.com/rhce/mock-exam-example.md) file.

This is not an official exam and certain topics not covered here (e.g., SELinux role usage) should also be studied to ensure you pass the exam.

### Sources

To create this exam simulation, I freely took inspiration from:
- Red Hat RHCE 8 (EX294) Cert Guide by Sander van Vugt
- Nehra Classes Youtube Channel
- Others


## 🏗️ Architecture

```
┌─────────────────┐    ┌────────────────────────────────────────┐
│  Control Node   │    │           Managed Nodes                │
│  (ansible-server)│────┤                                       │
│                 │    │  ┌─────┐ ┌─────┐ ┌───────┐ ┌─────────┐ │
│  • Ansible Core │    │  │dev  │ │test │ │prod   │ │balancer │ │
│  • Playbooks    │    │  │node1│ │node2│ │node3-4│ │  node5  │ │
│  • Roles        │    │  └─────┘ └─────┘ └───────┘ └─────────┘ │
│  • Collections  │    └────────────────────────────────────────┘
└─────────────────┘
```

```
ansible/
├── README.md
├── ansible.cfg               # Configuration file
├── inventory/
│   └── hosts                 # Static Inventory
├── requirements.yml          # Roles and Collections to start this repository
├── playbooks/
│   ├── yum-repo.yml          # 2
│   ├── packages.yml          # 3
│   ├── timesync.yml          # 4
│   ├── apache.yml            # 5
│   ├── squid.yml             # 7
│   ├── test.yml              # 8
│   ├── gen_hosts.yml         # 10
│   ├── hwreport.yml          # 11
│   ├── hwreport.yml          # 12
│   ├── create_users.yml      # 14
│   ├── cron.yml              # 15
│   ├── lvm.yml               # 16
│   ├── partition.yml         # 17
│   ├── selinux.yml           # 18
│   └── selinux2.yml          # 18
├── roles/
│   ├── apache/               # Custom role Apache
│   └── requirements.yml      # 6
├── templates/
│   ├── index.html.j2         # Template web server
│   └── hosts.j2              # Template file hosts
├── vars/
│   ├── vault.yml             # Criptography Variabils
│   └── users_list.yml        # Users List
├── scripts/
│   ├── ansible_navigator.sh  # Ansible Navigator Setup
│   ├── yum_repo_local.sh     # Local script repository setup
│   └── yum_repo.sh           # Script repository setup
└── tests/
    ├── syntax_check.sh                # Playbooks syntax test  --syntax-check 
    ├── syntax_check.txt               # Sample output from syntax_check.sh for reference
    ├── validation_script.sh           # Playbooks validation script
    └── rhce_validation_report.txt     # Sample output from validation_script for reference
    
```
To create a simple ansible project you can use my bash script [init-ansible-project.sh](https://github.com/rhce/init-ansible-project.sh)

### Prerequisites
```bash
# RHEL 8/9 o CentOS Stream
sudo dnf install ansible-core python3-pip git
```

### Installation
```bash
# Clone repository
git clone https://github.com/gabrielemorini/rhce.git
cd rhce

# Install roles
ansible-galaxy role install -r requirements-repo.yml

# Install collections
ansible-galaxy collection install -r requirements-repo.yml
```

### Test
```bash

# Syntax Check for all playbooks
./tests/syntax_check.sh

# Validation all configuration
./tests/validation_script.sh

```




