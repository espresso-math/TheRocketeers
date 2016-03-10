#!/usr/bin/env bash
set -e # halt script on error

zip -r website.zip _site

curl -H "Content-Type: application/zip" \
     -H "Authorization: Bearer $NETLIFYKEY" \
     --data-binary "@website.zip" \
     https://api.netlify.com/api/v1/sites/therocketeers.cr.rs/deploys

sed -i -e 's/cr.rs/github.io/g' _config.yml
jekyll build

cd _site

git config --global user.email "travis@alternate.path"
git config --global user.name "Travis CI"

git init
STR=$(date +%Y-%m-%d:%T)
git add --all
git commit -m "Update $STR"

git remote add origin https://$GITHUBKEY@github.com/TheRocketeers/TheRocketeers.github.io.git
git push --force origin master


