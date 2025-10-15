#!/usr/bin/env bash

set -ouex pipefail

#### Variables

# Must be over 1000
GID_ONEPASSWORDCLI="${GID_ONEPASSWORDCLI:-1600}"

echo "Installing 1Password"

# Import signing key
#rpm --import https://downloads.1password.com/linux/keys/1password.asc

# Now let's install the packages.
dnf -y install 1password-cli

# Clean up the yum repo (updates are baked into new images)
rm /etc/yum.repos.d/1password.repo -f

#####
# The following is a bastardization of "after-install.sh"
# which is normally packaged with 1password. You can compare with
# /usr/lib/1Password/after-install.sh if you want to see.

# onepassword-cli also needs its own group and setgid, like the other helpers.
chgrp "${GID_ONEPASSWORDCLI}" /usr/bin/op
chmod g+s /usr/bin/op

# remove the sysusers.d entries created by onepassword RPMs.
# They don't magically set the GID like we need them to.
rm -f /usr/lib/sysusers.d/30-rpmostree-pkg-group-onepassword-cli.conf
