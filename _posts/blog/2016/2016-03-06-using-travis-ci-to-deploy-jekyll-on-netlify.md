---
layout: post
title: "Using Travis CI to automatically deploy Jekyll on Netlify"
date: 2016-03-06T15:35:57+00:00
categories: [Blog]
share: true
excerpt: Setting up a Travis CI continuous workflow to automatically deploy my website on Netlify each time I push to Github.
tags: ["Travis CI", "Continuous Integration", "Netlify Static Hosting", "Jekyll"]
---

I recently moved my website from Github pages to Netlify. The reason I did this was because Netlify provides free static hosting through a worldwide CDN or in other words through a content delivery network. As a result my website is now blazingly fast anywhere around the world. Netlify CDN automatically optimizes my website resources so that they can be downloaded faster. Netlify is also convenient as it supports continuous integration which meant each time I made some modification and pushed to Github my site is automatically regenerated and deployed. Moving to Netlify also meant that I could use an SSL certificate with my custom domain for free. How cool is that?

The reason I write this post is that soon after I moved to Netlify I noticed that there was a build counter on their console that recorded how many times my site had been deployed and this build counter was red and perilously close to the 50 build mark. A bit of nosing around made me realize that Netlify only supports 50 automatic deployments from Github a month. But manual deployments were still free. I could drag and drop my website to upload but that was about it. 

To rectify this major inconvenience I searched around for ways to make this process as painless as possible. I finally stumbled on Travis CI. Travis CI is a continuous integration platform for developers to test their code on and was free for open source projects. But I found out that many people were using Travis CI for deploying jekyll to a variety of places. Travis CI is simple to use but the learning curve was a bit steep. I found the process very irksome since there was scarcely any resources where I could find help outside of the documentation. So I decided to write a how to style post on manually deploying to Netlify using their REST api.

#### Step 1

There are some files to added and scripts to be tweaked. In the root of your repositorysitory create a `.travis.yml` file. This is how you let Travis know what you want to do. Leave it empty for the moment. Create a two new bash files: `build.sh` and `deploy.sh` in a folder named `scripts` in the root folder of your repository. Make sure you have your `Gemfile` setup. Edit the `Gemfile` to include two new lines, `gem 'jekyll'` and `gem 'rake'`. Then make a file named `Rakefile` in your root folder and add the following code to it. 

```
task default: [:test]

task :test do
  ruby "tests.rb"
end
```

Now edit the `build.sh` file to add the following.

```
#!/usr/bin/env bash
set -e # halt script on error

jekyll build
```

Then edit the `deploy.sh` file to include this code.

```
#!/usr/bin/env bash
set -e # halt script on error

zip -r website.zip _site

curl -H "Content-Type: application/zip" \
     -H "Authorization: Bearer $NETLIFYKEY" \
     --data-binary "@website.zip" \
     https://api.netlify.com/api/v1/sites/<Your site domain name>/deploys
```

#### Editing the .travis.yml file

Open up the `.travis.yml` file you created earlier and add the following code.

```
language: ruby
rvm:
- 2.1

# install jekyll from gemfile
install: 
   - bundle install
   - rake
   - chmod +x ./scripts/build.sh
   - ./scripts/build.sh

# build site
scripts: true

# deploy to netlify
after_success: 
   - chmod +x ./scripts/deploy.sh
   - ./scripts/deploy.sh

# branch whitelist, only for GitHub Pages
branches:
  only:
  - master
```

#### Step 2

Make a new [Travis CI](https://travis-ci.org) and connect it to your Github account. Follow the instructions to activate your repository and push to Github for your first build. The build will fail, don't worry. In your Travis CI dashboard you can find the More Options button to your right. The settings for your repository will be there. In your settings page you have the option to add new environment variables. Setting up an environment variable enable you to access that variable in your bash script. Before you create an environmental variable you must create a Netlify personal access token for yourself. You can get the personal access token from [here](https://app.netlify.com/applications). Make sure to keep it safe. !!!Not in your repository!!!

Create a new environment variable called `NETLIFYKEY` and set it to the value of the personal access token.

Make some new changes to your site and push to Github and see the magic happen. 

#### Explanation

Travis essentially gives us a command line so that we can work with it. The `.travis.yml` file is used to indicate which scripts have to be run. First `bundle install` is run so that we have all our dependencies install. The rakefile is just there because Travis runs `bundle exec rake` automatically and we'd get an error if we didn't have some thing in it. Each shell script we run must be made executable with the `chmod +x` command. Then the `./` command runs the shell script. The first script `build.sh` runs the command `jekyll build` to generate your site into a folder called `_site`. The second script is run only if we have a successful build. `deploy.sh` first takes the content of the folder `_site` and then compresses it to make a zipped file `website.zip`. Then we use cURL to take this file and deploy it to Netlify using their REST API. 

#### Security Concerns

**Update fixed this**

Frankly, I think you shouldn't use the `deploy.sh` script if you're hosting your source code on a public Github repositorysitory. As you can see, you have a personal access token in that file and anyone can read it since it's on a public repository. I am currently trying to work around this problem by using gpg encryption. I'll post updates as I go along. I you have an idea that'll help me email me at {{site.owner.email}}



##### !Update!

I solved the security problem caused by keeping the key on your public repository by using environment variables. If you included the personal access token in your `deploy.sh` file make sure to change it to the above. !!!And make sure that you permanently delete any previous commits that includes this change from your repository.!!!