#!/bin/bash
# < me (at) alexiobash (dot) com >
# https://www.alexiobash.com
#
# Backup running Virtual Machine in XenServer + METADATA
#
# to restore:
# cd $BACKUPPATH
# xe vm-import filename=vm-backup.xva

DATA=$(date +%F)
UUIDFILE="/tmp/uuids.txt"
IPNAS=""
SHARE=""
DEST="/backup_VM"
BACKUPPATH="$DEST/$DATA"
LOG="/var/log/backup_snap.log"

function snap_backup () {
	for VMUUID in $(cat $UUIDFILE)
	do
		echo -e "`date` - START Backup VM $VMNAME" >> $LOG
		VMNAME=`xe vm-list uuid=$VMUUID | grep name-label | cut -d":" -f2 | sed 's/^ *//g'`
		SNAPUUID=`xe vm-snapshot uuid=$VMUUID new-name-label="SNAP-$VMNAME-$DATA"`
		xe template-param-set is-a-template=false ha-always-run=false uuid=$SNAPUUID
		xe vm-export vm=$SNAPUUID filename="$BACKUPPATH/$VMNAME-$DATA.xva"
		# backup metadata
		xe vm-export filename="$BACKUPPATH/$VMNAME-"$DATA"-METADATA" uuid=$VMUUID metadata=true 
		xe vm-uninstall uuid=$SNAPUUID force=true
		# compress backup
		#gzip -9 "$BACKUPPATH/$VMNAME-$DATA.xva"
		echo -e "`date` - END Backup VM $VMNAME" >> $LOG
	done
}

function create_list () {
	xe vm-list is-control-domain=false is-a-snapshot=false | grep uuid | cut -d":" -f2 > $UUIDFILE
}

# check
if [[ -f /tmp/snap_backup.lck ]]; then echo "Backup is running..."; exit 1; fi
touch /tmp/snap_backup.lck

# check
if [[ ! -d $DEST ]]; then mkdir -p "$DEST"; fi

# mount and backup
mount -t nfs "$IPNAS":"$SHARE" "$DEST"
if [[ $? = 0 ]]; then
	if [[ ! -d $BACKUPPATH ]]; then mkdir -p "$BACKUPPATH"; fi
	create_list
	snap_backup
else
	echo "Error mount nfs share"
	exit 1
fi

# unmount
umount $DEST

rm -f /tmp/snap_backup.lck
exit 0
# end script
