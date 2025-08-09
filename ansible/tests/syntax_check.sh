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
  echo "${CURRENT_USER}"
  echo "No playbooks found in ${ANSIBLE_BASE_DIR}/playbooks/"
  exit 1
fi

# Move into base directory so paths are relative
cd "$ANSIBLE_BASE_DIR" || exit 1

# Loop through each playbook
for playbook in "${PLAYBOOKS[@]}"; do
  relative_path="${playbook#$ANSIBLE_BASE_DIR/}"  # rimuove la parte assoluta
  echo "Running syntax check for $relative_path"
  if ansible-playbook "$relative_path" --syntax-check; then
    echo "✅ Syntax check passed for $relative_path" >> tests/syntax_check.txt
  else
    echo "❌ Syntax check failed for $relative_path" >> tests/syntax_check.txt
  fi
done

