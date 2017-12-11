 su $1 -c "mkdir ~/.ssh"
 su $1 -c "cat /vagrant/.setting/public_key>>~/.ssh/authorized_keys"
 su $1 -c "chmod 700 ~/.ssh"
 su $1 -c "chmod 600 ~/.ssh/authorized_keys"