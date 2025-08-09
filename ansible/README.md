
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