#!/bin/sh -eux

# This system is built using Bento project work
# All rights go to Bento project
# More information can be found at https://github.com/chef/bento'

# set a default HOME_DIR environment variable if not set
HOME_DIR="${HOME_DIR:-/home/vagrant}";

VER="`cat $HOME_DIR/.vbox_version`"
ISO="VBoxGuestAdditions_$VER.iso"
mkdir -p /tmp/vbox
mount -o loop $HOME_DIR/$ISO /tmp/vbox
sh /tmp/vbox/VBoxLinuxAdditions.run \
    || echo "VBoxLinuxAdditions.run exited $? and is suppressed." \
        "For more read https://www.virtualbox.org/ticket/12479"
umount /tmp/vbox
rm -rf /tmp/vbox
rm -f $HOME_DIR/*.iso