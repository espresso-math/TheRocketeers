#!/usr/bin/env bash
set -e # halt script on error

curl http://pooleapp.com/data/$POOLEKEY.yaml > _data/poole.yaml # get comments from pooleapp.com
jekyll build
