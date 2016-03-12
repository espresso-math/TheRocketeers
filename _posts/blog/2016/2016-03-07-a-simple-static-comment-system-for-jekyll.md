---
layout: post
categories: [blog]
share: true
date: 2016-03-07T10:30:24+00:00
title: A Simple Self-hosted Static Comment System for Jekyll
tags: ["Static Comment System", "Jekyll"]
poole: true
---

I've had my eyes on a comment system for my website for some time now. The only thing holding me back is the relative lack of a simple static system suitable for a small blog. One of my big concerns about the commenting systems that exist today is the lack of anonymity and the way that they harvest user data. Their business model is based on the false premise that users want targeted advertisements as an opt-out instead of as an opt-in. They are actually taking advantage of the fact that most people do not take the effort to opt out or are unaware that such a feature exists. Take Disqus for example. Disqus integration in a website can make the webpage excruciatingly slow. Besides that they load advertisements or click baits on the side. Their aim is to use your precious website traffic to make money. Now, it can be argued that such tactics help keep their service free of charge. But you do have to realize that implementing a comment system is not a difficult task. The money they make off your website traffic is much greater than the cost of their service - sometimes disproportionately so. It's not all about money. It's unethical to force your readers to read click baits that you yourself would rather die first than read. 

One thing I've learned about the web is that if you want to get something done go ahead and do it yourself. So I decided to make my own comment system that would be open source and could be self hosted. 

####Introducing Agora

You can include the Agora comment system on your jekyll website by simply adding the following file to your `_includes` directory. Every time you'd want to use Agora go ahead and add `{% include agora-comments.html %}` to your post. It's that simple. All the javascript and css that make Agora tick is included inside the html file. Agora uses [Pooleapp.com](http://pooleapp.com) to handle form submissions. Being static the comments do not appear at once. Instead each time you rebuild and update your jekyll site the comments appear. But before you can do that read on to know how to configure Agora.

####Configuration

Go to [Pooleapp.com](http://pooleapp.com), make your poole account and create your first form. Poole gives you two md5 checksums to use in your comments - an api key and a secret key. You can include the api key inside the `agora-comments.html` file by editing the action attribute of the comment form.

```
<form action="https://pooleapp.herokuapp.com/stash/{your api key here}/" method="post">
```

Then set the url where the user will be redirected to after submission by editing this line
```
<input type="hidden" name="redirect_to" value="{redirect url}">
```

That's all that's required.

Now each time your form has been submitted it will appear on Poole. To include this data in your website `cd` into your jekyll site and use curl to get the data with the secret key as a `yaml` file and save it in the `_data` folder in the root of your jekyll site.

```
curl http://pooleapp.com/data/{your secret key}.yaml >> _data/poole.yaml
```

Do this each time just before you build your website using `jekyll build`. In fact try packaging the above two lines of code in a bash file that you can conveniently run when you're ready to deploy.



