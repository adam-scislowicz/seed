#!/bin/sh

if ! test -d .secure-staging; then
    mkdir -p .secure-staging/gpg-metadata
fi

gpg --export --export-options backup --output .secure-staging/gpg-metadata/public.gpg
gpg --export-secret-keys --export-options backup --output .secure-staging/gpg-metadata/private.gpg
gpg --export-ownertrust > .secure-staging/gpg-metadata/trust.gpg

tar -cvjf gpg-metadata.tar.bz2 -C .secure-staging gpg-metadata
