# Enable nullglob
shopt -s nullglob

# Create output directory
mkdir -p tests
> tests/syntax_check.txt

# Collect all playbooks
CURRENT_USER=$(whoami)
ANSIBLE_BASE_DIR="/home/${CURRENT_USER}/ansible"
PLAYBOOKS=("${ANSIBLE_BASE_DIR}"/playbooks/*.yml)

# If no playbooks are found, exit
if [ ${#PLAYBOOKS[@]} -eq 0 ]; then
  echo ${CURRENT_USERUSER}
  echo "No playbooks found in ${ANSIBLE_BASE_DIR}/playbooks/"
  exit 1
fi

# Loop through each playbook
for playbook in "${PLAYBOOKS[@]}"; do
  echo "Running syntax check for $playbook"
  if ansible-playbook "$playbook" --syntax-check; then
    echo "✅ Syntax check passed for $playbook" >> tests/syntax_check.txt
  else
    echo "❌ Syntax check failed for $playbook" >> tests/syntax_check.txt
  fi
done
