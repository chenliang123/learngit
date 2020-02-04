#!/bin/bash

while [[ "$#" > 0 ]]; do case $1 in
  -r|--release) release="$2"; shift;;
  -b|--branch) branch="$2"; shift;;
  *) echo "Unknown parameter passed: $1"; exit 1;;
esac; shift; done

# Default as minor, the argument major, minor or patch:
if [ -z "$release" ]; then
    release="patch";
fi

echo "Release as $release"

# Default release only at master
function obtain_git_branch {
  br=`git branch | grep "*"`
  echo ${br/* /}
}

result=`obtain_git_branch`
echo Current git branch is $result

if [ "$result" != "master" ]; then 
  exit 1;
fi

# Tag prefix
prefix="zh_v"

git pull origin $result
echo "Current pull origin $result."

# Generate version number and tag
standard-version -r $release --tag-prefix $prefix --infile CHANGELOG.md

git push --follow-tags origin $result

echo "Release finished."
