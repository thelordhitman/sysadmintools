#!/bin/bash

# sum up UUID's space separated
uuids="cd361b86-4d33-472c-ba9c-ecb40e05ac89 56f3ff13-0103-4f19-a333-70c0bf810b08"
count=0

for uuid in $uuids 
	do
		if [ -e /dev/disk/by-uuid/$uuid ]
			then usb=$uuid ; let count=count+1
		fi
	done

case count in 
	0)
		echo "Error: no defined disk available."
		exit
		;;
	1)
		true
		;;
	*)
		# put next line in comment if you just want to use the last detected disk from more than one available
		# echo "Error: more than one disk available." ; exit
		;;
esac

# $usb hold the uuid of the disk we want to mount
# we check if it is already mounted, and if not, we mount it

if $(grep -q $(readlink -f /dev/disk/by-uuid/$usb) /etc/mtab )
	then 
		echo Disk $(readlink -f /dev/disk/by-uuid/$usb) was already mounted.
		elif $(mount /dev/disk/by-uuid/$usb)
			then echo Disk $(readlink -f /dev/disk/by-uuid/$usb) was mounted.
	else echo Disk $(readlink -f /dev/disk/by-uuid/$usb) failed to mount at $(date). ; exit
fi

## execute command on mounted disk here
exit

## umount afterwards
if $(umount /dev/disk/by-uuid/$usb)
        then true
        else echo Unmounting disk failed at $(date).
fi
