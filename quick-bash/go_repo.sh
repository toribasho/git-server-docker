#!/bin/bash

REPO_NAME=$1

cd $REPO_NAME

cat > dependency.yml <<EOF
project:
    name: "$REPO_NAME"
EOF