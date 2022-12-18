#!/usr/bin/env -S bash

NAME=$1
EMAIL=$2
PASSWORD=$3
#COMMENT=$4

if ! test -d .secure-staging; then
    mkdir -p .secure-staging
fi

cat >.secure-staging/gpg-batch-key.txt  <<EOF
%echo "Generating ECC keys (sign & encr) with no-expiry"
  Key-Type: EDDSA
    Key-Curve: ed25519
  Subkey-Type: ECDH
    Subkey-Curve: cv25519
  Name-Real: $NAME
  Name-Email: $EMAIL
  Expire-Date: 0
  Passphrase: $PASSWORD
  %commit
%echo Done
EOF
gpg2 --batch --full-generate-key --expert .secure-staging/gpg-batch-key.txt

# Name-Comment: $COMMENT
# %pubring foo.pub
# %secring foo.sec
