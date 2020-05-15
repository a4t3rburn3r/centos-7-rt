#!/bin/sh -eux

# This system is built using Bento project work
# All rights go to Bento project
# More information can be found at https://github.com/chef/bento'

motd_string='
This system with real time kernel is built using Bento project work
More information can be found at
https://github.com/a4t3rburn3r/centos-7-rt
https://github.com/chef/bento
'

if [ -d /etc/update-motd.d ]; then
    MOTD_CONFIG='/etc/update-motd.d/99-motd-message'

    cat >> "$MOTD_CONFIG" <<REALTIME
#!/bin/sh

cat <<'EOF'
$motd_string
EOF
REALTIME

    chmod 0755 "$MOTD_CONFIG"
else
    echo "$motd_string" >> /etc/motd
fi
