#! /bin/bash

#target server deatils
ISCSI_TARGET_IP="192.168.1.112"
ISCSI_TARGET_PORT="3260"
ISCSI_TARGET_IQN="iqn.1994-05.com.redhat:d5cdfb584c3e"

#install the packages
sudo yum install iscsi-initiator-utils -y

# start and enabled the service
sudo systemctl enable --now iscsid

#iscusi initioart name 
ISCSCI_INITORNAME_NAME=`(cat /etc/iscsi/initiatorname.iscsi | awk -F = '{print $2}')`

#Scan & Find  the iscsci Traget IQN
iscsiadm -m discovery -t sendtarget -p $ISCSI_TARGET_IP:$ISCSI_TARGET_PORT

#Connecr the iscsi target shared luns in the local machine 
iscsiadm -m node -T $ISCSI_TARGET_IQN $ISCSI_TARGET_IP:$ISCSI_TARGET_PORT -l

#Wait for the device to be ready
sleep 5

NEW_DEVICE=$(iscsiadm -m session -P3 | awk '/Attached scsi disk/ { print $4; exit }')
if [ -z $NEW_DEVICE ]
then
echo "Failed to find the lun"
exit 1
fi

#echo -e "n\np\n1\n\n\nw" | fdisk /dev/$NEW_DEVICE

#Create the new file sysmtem on ext4
mkfs.ext4 /dev/$NEW_DEVICE

#create the mount point
NEW_MOUNT=/opt/Pramod

#mount 

mount /dev/$NEW_DEVICE $NEW_MOUNT
