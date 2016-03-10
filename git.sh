#!/usr/bin/env bash
set -e # halt script on error

STR=$(date +%Y-%m-%d:%T)
git add --all
git commit -m "Update $STR"
git push origin master