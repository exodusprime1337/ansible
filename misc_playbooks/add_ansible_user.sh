PASSHASH='$6$ZJst7txeHIny6aps$W0k7b9M9z2qDbkqNsd9j3FC2MBTlQzDQciaLhASofB7m1PGk9F9MyGH/ECXEkbrvdheSQxvBZd37Iv9mfZQm4/'

for host in 192.168.2.53; do
ssh -tt kenny@$host <<EOF &
set -e

# Create user (ignore error if exists)
sudo useradd -m -s /bin/bash -p '$PASSHASH' ansible 2>/dev/null || true
sudo usermod -p '$PASSHASH' ansible

# Ensure SSH directory exists with correct ownership FIRST
sudo mkdir -p /home/ansible/.ssh
sudo chown ansible:ansible /home/ansible/.ssh
sudo chmod 700 /home/ansible/.ssh

# Write authorized_keys safely
sudo tee /home/ansible/.ssh/authorized_keys >/dev/null <<KEYS
$(cat ~/.ssh/ansible-keys.pub)
KEYS

# Fix permissions
sudo chown ansible:ansible /home/ansible/.ssh/authorized_keys
sudo chmod 600 /home/ansible/.ssh/authorized_keys

# Enable passwordless sudo
echo 'ansible ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/ansible >/dev/null
sudo chmod 440 /etc/sudoers.d/ansible

EOF
done
wait