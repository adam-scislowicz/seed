#!/bin/sh

COMMENT=$1

ssh-keygen -t ed25519 -C"$COMMENT"