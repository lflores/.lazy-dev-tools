#!/bin/bash
echo "switching to develop branch.."
git branch | grep 'develop' | xargs -n 1 git checkout
echo "fetching with -p option...";
git fetch -p;
echo "running pruning of local branches"
git branch -vv | grep ': gone]'|  grep -v "\*" | awk '{ print $1; }' | xargs -r git branch -d;
