# Install ansible-navigator¶
# Install the python package manager using the system package installer (e.g.):
sudo dnf install python3-pip

# Install ansible-navigator:
python3 -m pip install ansible-navigator --user

# Add the installation path to the user shell initialization file (e.g.):
echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.profile

# Refresh the PATH (e.g.):
source ~/.profile

# Launch ansible-navigator:
ansible-navigator

# ansible-navigator triggers a one-time download of the demo execution-environment image.