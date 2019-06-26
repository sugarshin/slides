#!/bin/bash

set -eu

readonly git_url=git@github.com:sugarshin/slides.git
readonly branch=gh-pages
readonly commit=$(git rev-parse --short HEAD)
readonly dist=dist
readonly dir=.deploy

rm -rf $dir
git clone --depth=1 $git_url -b $branch $dir || (git init $dir && cd $dir && git remote add origin $git_url && git checkout -b $branch)
rm -rf ${dir}/*
cp -R ${dir}/../${dist}/. $dir
cd $dir
git add --all
git commit -m "Built artifacts of $commit [ci skip]" || true
git push origin $branch
