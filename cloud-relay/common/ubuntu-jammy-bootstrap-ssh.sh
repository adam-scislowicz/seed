#!/bin/sh

apt update
apt install -y \
    netcat

mkdir -p /home/ubuntu/.ssh

cat > /home/ubuntu/.ssh/id_ed25519 <<EOF
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
QyNTUxOQAAACBTtu56v63ynwXZ0QEO7qDLnGhw99tdKLRx+WCVtGpcEAAAAJjBT2vOwU9r
zgAAAAtzc2gtZWQyNTUxOQAAACBTtu56v63ynwXZ0QEO7qDLnGhw99tdKLRx+WCVtGpcEA
AAAEAtpIyHDWUskNaAhu0FoQR3YkTbVoYBQGJxUgKu53evDlO27nq/rfKfBdnRAQ7uoMuc
aHD3210otHH5YJW0alwQAAAAEXVzZXJAMzZjMDZjNTI2NDBiAQIDBA==
-----END OPENSSH PRIVATE KEY-----
EOF

chown ubuntu.ubuntu /home/ubuntu/.ssh/id_ed25519
chmod 400 /home/ubuntu/.ssh/id_ed25519
