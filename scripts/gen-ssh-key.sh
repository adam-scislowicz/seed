#!/bin/sh

OUTPUTFILE=$1

ssh-keygen -t ed25519 -f$OUTPUTFILE
