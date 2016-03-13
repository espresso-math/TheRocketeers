#!/usr/bin/env bash
set -e # halt script on error

curl https://whispering-everglades-91567.herokuapp.com/get_comments.yaml >> _data/poole.yaml # get comments from pooleapp.com
jekyll build
