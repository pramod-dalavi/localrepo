#! /bin/bash


#Install the required packages
sudo yum  install targetcli iscsi-initiator-utils -y
# start and enable the service
sudo systemctl enable --now iscsid

#start and enable the target service
sudo systemcrl enable target --now

#configure  the iSCSI target 
sudo targetcli backstores/fileio create disk01 /opt/iscsi_disk 2G 
sudo  targetcli iscsi/ create iqn.1994-05.com.redhat:d5cdfb584c3e
sudo  targetcli iscsi/iqn.1994-05.com.redhat/tpg1/luns create backstores/fileio/disk01
sudo targetcli iscsi/iqn.1994-05.com.redhat/tpg1/acls/ create iqn.1994-05.com.redhat:7f72cb43824

#Configure firewall rules 
sudo firewall-cmd --add-service=iscsi-target --permanent
sudo firewall-cmd --add-port=3260/tcp --permanent
sudo firewall-cmd --reload

echo "Complete the configuration"
