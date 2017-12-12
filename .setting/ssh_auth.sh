#!/usr/bin/env bash
su $1 -c "mkdir ~/.ssh"
su $1 -c "cat /vagrant/.setting/public_key>>~/.ssh/authorized_keys"
su $1 -c "chmod 700 ~/.ssh"
su $1 -c "chmod 600 ~/.ssh/authorized_keys"
su $1 -c "cat /vagrant/.setting/private_key>~/.ssh/id_dsa"
su $1 -c "chmod 600 ~/.ssh/id_dsa"
su $1 -c "echo 'StrictHostKeyChecking no'>~/.ssh/config"