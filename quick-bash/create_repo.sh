#!/bin/bash

# arg $1 as repo name
# arg $2 as repo storage
# arg $3 as repo path

myrepo=$1

mkdir $myrepo

cd $myrepo

git init --shared=true
git add .
git commit -m "my first commit"
cd ..
git clone --bare $myrepo $myrepo.git

mv $myrepo.git $2 

rm -rf $myrepo

git clone ssh://git@127.0.0.1:2222/git-server/repos/$3/$myrepo.git

echo "Done"

