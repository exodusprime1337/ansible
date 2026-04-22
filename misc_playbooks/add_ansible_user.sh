PASSHASH='$6$ZJst7txeHIny6aps$W0k7b9M9z2qDbkqNsd9j3FC2MBTlQzDQciaLhASofB7m1PGk9F9MyGH/ECXEkbrvdheSQxvBZd37Iv9mfZQm4/'

for host in 192.168.2.50; do
cat ~/.ssh/ansible-keys.pub | ssh kenny@$host "
sudo useradd -m -s /bin/bash -p '$PASSHASH' ansible 2>/dev/null || true;
sudo usermod -p '$PASSHASH' ansible;
sudo mkdir -p /home/ansible/.ssh;
sudo tee /home/ansible/.ssh/authorized_keys >/dev/null;
sudo chown -R ansible:ansible /home/ansible/.ssh;
sudo chmod 700 /home/ansible/.ssh;
sudo chmod 600 /home/ansible/.ssh/authorized_keys;
echo 'ansible ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/ansible;
sudo chmod 440 /etc/sudoers.d/ansible
" &
done
wait


