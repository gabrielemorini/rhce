# RHCE 9 - Red Hat Certfied Engineer - Exam Simulation 

## 📋 Introduction

This repository contains my complete implementation of **RHCE (Red Hat Certified Engineer)** exam objectives. 

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

# Setup environment
./scripts/setup.sh

# Roles and Collections installations
ansible-galaxy install -r roles/requirements.yml
```
