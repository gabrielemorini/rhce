# RHCE 9 - Red Hat Certfied Engineer - Exam Simulation 

## 📋 Introduction

This repository contains my complete implementation of **RHCE (Red Hat Certified Engineer)** exam objectives. Click on [mock-exam-example.md](https://github.com/rhce/mock-exam-example.md) to start!

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
rhce-ansible-project/
├── README.md
├── ansible.cfg               # Configurazione principale Ansible
├── inventory/
│   ├── hosts                 # Inventory statico
│   └── group_vars/           # Variables per gruppi
├── playbooks/
│   ├── site.yml              # Playbook principale
│   ├── packages.yml          # Gestione pacchetti
│   ├── timesync.yml          # Sincronizzazione tempo
│   ├── user_management.yml   # Gestione utenti
│   ├── storage.yml           # Configurazione storage
│   └── security.yml          # Hardening sicurezza
├── roles/
│   ├── apache/               # Ruolo custom Apache
│   ├── common/               # Configurazioni comuni
│   ├── requirements-repo.yml # Roles and Collections to start this repository
│   └── requirements.yml      # Ruoli Ansible Galaxy
├── templates/
│   ├── index.html.j2         # Template web server
│   └── hosts.j2              # Template file hosts
├── vars/
│   ├── vault.yml             # Variabili crittografate
│   └── user_list.yml         # Lista utenti
├── scripts/
│   ├── yum-repo-local.sh     # Local script repository setup
│   └── yum-repo.sh           # Script repository setup
└── docs/
    ├── installation.md       # Guida installazione
    ├── usage.md              # Guida utilizzo
    └── troubleshooting.md    # Risoluzione problemi
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

# Install roles
ansible-galaxy role install -r requirements-repo.yml

# Install collections
ansible-galaxy collection install -r requirements-repo.yml
```
