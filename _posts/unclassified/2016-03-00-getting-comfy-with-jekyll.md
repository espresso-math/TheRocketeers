---
layout: post
categories: [blog]
share: true
date: 2016-04-10T07:02:58-05:00
title: Getting comfy with Jekyll
---
I don't intend this to be a "how to" style post. If you're unfamiliar with Jekyll and Git then you'd better leave this post alone. Try reading some of my [other posts](https://therocketeers.cr.rs/tags/) instead. 

Jekyll can be a bitch if you're new to static blogging. For starters, Jekyll does not have a shiny content editor like Wordpress or Ghost. And to be honest that's the way I like her. But the frustrating thing about making a blog with Jekyll is the way I have to host it. Right now this blog is hosted with [Netlify](https://www.netlify.com) and the source code is on Github. After manually adding each post I trigger [Travis CI](https://travis-ci.org) with a push to github. Travis builds and then deploys the generated code to Netlify using their api. This problem mainly stems from the fact that Netlify is a CDN (Content Delivery Network) and can only work with static files. That means no server side scripts for me.

To get around this problem you need a minimal content editor -- a place where you bring together all your different tools in one place so that they can all interact. Right now the tools I use are Github, Netlify, Travis-CI and [Heroku](https://heroku.com) along with [Draft](https://draftin.com) -- a version controlled, online text editor for writers. That's a long list and I wish I could narrow it down to a few basic tools. Barring that my only other choice was to create an app that would bring all these different tools together to create an optimized work flow. 

The script I wrote for this purpose gradually grew and became almost 500 lines of nodejs code. I call it Burlesque, because its complicated and messy. The first and major function for Burlesque was to act as a comment server. The other functions grew from this. Right now Burlesque has the ability to block spammers and to act as a Gravatar proxy server. Besides this Burlesque also has a webhook for publishing directly from Draft.

Each of these features requires a lot of explanation. You can find each of these below.