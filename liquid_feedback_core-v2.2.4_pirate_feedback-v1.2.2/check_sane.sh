#!/bin/bash
# display information about the running system
# must be run as root

# read configuration
path=$( dirname $( readlink -f $( dirname $0 ) ) )
source $path/liquid_feedback_core/config

echo
echo "==== /etc/init.d/lf_updated status"
/etc/init.d/lf_updated status
echo "==== /etc/init.d/lf_notification status"
/etc/init.d/lf_notification status
echo "==== /etc/init.d/lighttpd status"
/etc/init.d/lighttpd status
echo "==== /etc/init.d/postgresql status"
/etc/init.d/postgresql status

echo
echo "==== ps aux | grep lf_"
ps aux | grep lf_

echo
echo "==== tail /var/log/pirate_feedback/notification.log"
tail /var/log/pirate_feedback/notification.log
echo
echo "==== tail /var/log/syslog"
tail /var/log/syslog
echo
echo "==== tail /var/log/messages"
tail /var/log/messages

echo
echo "==== ls -l ` dirname $exportfile ` | tail"
ls -l ` dirname $exportfile ` | tail
echo
echo "==== ls -l ` dirname $member_import_csvfile `| tail"
ls -l ` dirname $member_import_csvfile ` | tail
echo
echo "==== ls -l ` dirname $member_import_csvfile_processed `| tail"
ls -l ` dirname $member_import_csvfile_processed ` | tail

echo
