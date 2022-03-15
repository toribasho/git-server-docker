#!/bin/bash

# arg $1 as repo name
# arg $2 as repos internal path

local_repo_path=/media/tori/541c6833-3172-4b9f-a747-4d48ec0483c3/repo/git_repo/repos
myrepo=$1
#sub_repo_path=$2
sub_repo_path=pivp/crystal

mkdir $myrepo

cd $myrepo

git init --shared=true
git add .
git commit -m "create repo"
cd ..
git clone --bare $myrepo $myrepo.git

scp -r $myrepo.git tori@192.9.200.190:$local_repo_path/$sub_repo_path

rm -rf $myrepo

git clone ssh://git@192.9.200.190:2222/git-server/repos/$sub_repo_path/$myrepo.git

echo "Done"

