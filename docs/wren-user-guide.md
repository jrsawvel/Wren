# Wren User Guide


The commands below will follow `http://yourdomain`.


### Login

Wren is a single-user app. No account creation process exists, and Wren supports two different no-password login mechanisms. 

To receive the login activation link, a user visits `/wren/login` and enters the email address stored in the Wren YAML configuration file.

If the email address entered matches, then Wren sends a message that contains the login activation link.

The login link can be used only one time. The link contains session information related to the login.

A Wren user can also login with [IndieAuth](https://indieauth.com/), which is an [IndieWeb](https://indieweb.org) project. The user enters the URL for the Wren website or another personal website. This website must be connected to an account at Twitter, GitHub, Facebook, or Google. Within the homepage of the Wren site, the URL to one of the above services must be listed. At that other service, the profile page must contain the URL to the personal website used for logging in with IndieAuth. When logging into Wren with IndieAuth, the user must also be logged into the other service. Nothing email related is used when logging in with IndieAuth.


### Create a Post

Wren posts can be created and updated through a web browser on a desktop/laptop computer or on a mobile device. 

The author visits `/wren/create`. A large textarea box is displayed. This can be used to preview and create a post, or the JavaScript editor can be brought up by clicking the "editor" link.



### Update a Post

While viewing the web page to edit, the author interject into the URL `/wren/update` between the site's domain name and the name of the web page.

This will display the post in a large textarea box. The author can choose to edit the post within the JavaScript editor by clicking the "editor" link.



### Logout

`/wren/logout`



### Markup

Wren supports Markdown, MultiMarkdown, and HTML.

Wren supports the following custom formatting commands:

* `fence. fence..` - to be used around a large code block when indenting each line with four spaces is tedious.
* three back tics at the start and end of a code block.

The Wren Markdown is lightly flavored.

* Newlines or hard line breaks are preserved and get converted to the HTML BR tag. This default behavior can be overridden per above.
* If desired, raw URLs can be converted to clickable links with the above command.
* Two minus signs on both sides of text will surround the text with the HTML SMALL tag.



### Power Commands

Special Wren commands are listed within HMTL comments in the markup.

* `<!-- toc : yes -->` - create a table of contents. default is NO.
* `<!-- url_to_link : yes -->` - auto-link raw URLs. default is NO. 
* `<!-- newline_to_br : no -->` - preserve hard line breaks in html. default is YES. 
* `<!-- slug : slugname -->` - example for the homepage = `slug:index`
* `<!-- dir:directory-location -->` - example = `dir:2006/03/24`
* `<!-- template : customarticle -->`
* `<!-- imageheader : http://url-to-image -->`
* `<!-- description : sub-title text to display over image header -->`
* `<!-- reply_to : URL -->` - create a [Webmention](https://indieweb.org) reply post for the listed URL. Wren will automatically send the reply to the domain name listed within the URL for the post being replied to. 
* `<!-- syn_to : twitter -->` - or some other social media service. this tells Wren to syndicate the newly created post to Twitter or to whatever service is listed. Wren will make a Webmention post to [brid.gy](https://brid.gy), which will make the post to the user's Twitter account. the user must register at brid.gy. if other Twitter users reply to the tweet, brid.gy will grab that info and post it to the Wren website as a Webmention.


CSS can be included, which can override the default CSS or to add new display options.

To use custom CSS in a post, do the following:

    <!-- css_start 
    body {background: yellow;}
    css_end --> 

The starting and ending comment lines must occur at the beginning of a line.



### Files

To access the markup text version of a post, replace `.html` at the end of the URL with `.txt`.

Wren maintains a list of all links to posts in a file called `links.json`. Wren uses this file to create `rss.xml`, `sitemap.xml`, and `mft.html`. 

`mft.html` lists the most recent posts in an HTML file that uses [Microformats](http://microformats.org/wiki/microformats2). Some [Indieweb users](https://indiewebcamp.com/) prefer to syndicate their content by marking up their HTML files with Microformats. These HTML pages are called h-feeds. Parsers would read a user's homepage or a sidefile page, such as Wren's mft.html, to create a feed to be read by someone else, instead of accessing the author's RSS feed.



### Configuration

In the Wren YAML configuration file, the following directories need to be specified. The first two should be created outside of document root.

*  `markup_storage : /home/wren/markup` - for easy download, backup
*  `session_id_storage : /home/wren/sessionids`
*  `versions_storage : <html doc root>/versions`



### Search

Create an article page with the following input form fields.

Wren's built-in search:

    <p>
     <form action="/wren/search" method="post">
      <input size="31" type="text" name="keywords" autofocus>
      <input class="submitbutton" type=submit name=sb value="Wren Search">
     </form>
    </p>


If Google has indexed the site, then include the following HTML to get Google search results:

    <p>
     <form method="GET" action="http://www.google.com/search">
      <input type="text" name="q" size="31" maxlength="255" value="">
      <input class="submitbutton" type=submit name=btnG VALUE="Google Search">
      <input type=hidden name=domains value="http://yoursite.com">
      <input type=hidden name=sitesearch value="http://yoursite.com">
     </form>
    </p>



### IndieWeb

This is example HTML that would appear on the homepage. The markup below supports IndieAuth, Webmentions, Micropub, and h-feed.

    <!doctype html>
    <html lang="en">
    <head>
    <title>Your Website | Homepage</title>
    <meta charset="UTF-8" /> 
    <meta name=viewport content="width=device-width, initial-scale=1">
    <link rel="alternate" type="application/rss+xml" href="http://yourwebsite/rss.xml" />
    <link rel="alternate" type="application/json" title="JSON Feed" href="http://yourwebsite/feed.json" />
    <link rel="feed" type="text/html" title="Microformatted HTML feed page" href="http://yourwebsite/mft.html" /> 
    <link rel="webmention" href="http://yourwebsite/api/v1/webmentions" />
    <link rel="micropub" href="http://yourwebsite/api/v1/micropub" />
    <link rel="token_endpoint" href="https://tokens.indieauth.com/token" />
    <link rel="authorization_endpoint" href="https://indieauth.com/auth" />
    <link rel="me" href="https://github.com/yourgithubaccount" />
    <link rel="me" href="https://twitter.com/yourtwitteraccount" />
    </style>
    </head>
    <body>



#### IndieAuth

Wren supports logging in with IndieAuth, but it's limited only to the site owner, of course. For a website that supports multiple people to login via IndieAuth, such as [indieweb.org](https://indieweb.org), then I would enter my website domain name. The process would check my homepage, parsing for the `rel="me"` lines. 

Then I could complete to login procedure by choosing to use either my Twitter or GitHub account. If I'm not logged into one of those other services, then I will need to login to complete the IndieAuth login process.

For this example, both my GitHub and Twitter profile pages must contain the URL to my website.

    <link rel="authorization_endpoint" href="https://indieauth.com/auth" />
    <link rel="me" href="https://github.com/yourgithubaccount" />
    <link rel="me" href="https://twitter.com/yourtwitteraccount" />

Users can install an IndieAuth server on their own hosted server, but I choose to rely on another IndieAuth server.



#### Receiving Webmentions

When others want to post replies to a Wren website, and if their web publishing apps support sending Webmentions, then their code will search the Wren website's homepage for Wren's Webmention endpoint.

    <link rel="webmention" href="http://yourwebsite/api/v1/webmentions" />

A person could also use the cURL command-line utility to post a Webmention manually to Wren's Webmention endpoint.

    curl -i -d "source=http://elsewhere.com/a-reply-post.html&target=http://yourwebsite/my-opinion-about-something.html" http://yourwebsite/api/v1/webmentions



#### Sending Webmentions

To send a Webmention to another website, this command must be included in the Wren post markup. The URL points to the the post being replied to. It's called the **target URL**. 

    <!-- reply_to : target URL -->

When replying to a post on another website that accepts Webmentions, it might be worthwhile to add the following Microformat class around the opening paragraph in the Wren post markup.

    <span class="p-summary">This might be the opening paragraph in my Webmention post that is a reply to a post found on another website.</span>

Website owners who accept Webmentions can display them in any manner that they desire. Some users choose to display only a snippet of the reply if the Webmention reply contains the `p-summary` class. Otherwise only a link back to the website that created the Webmention gets displayed.




#### Syndicating to Social Media

To syndicate to Twitter or other social media services, supported by [brid.gy](https://brid.gy), the following command needs to be included in the Wren markup for the post. 

    <!-- syn_to : twitter -->

In the above example, I want the post syndicated to my Twitter account that brid.gy knows about because I registered at my domain name and Twitter account at brid.gy.

Wren will make a Webmention post to brid.gy, and then brid.gy will syndicate the post to my Twitter account.

If title text exists for the Wren post, then that text will appear in the tweet because the Microformat class `p-name` was used with the `h1` tag.

Example: 

    <h1 class="p-name">Posting to Twitter via Brid.gy</h1>

A user does not have to add the `p-name` class because it's built into Wren's templates for article and note posts.

In the IndieWeb world, an article is defined as a post that has a title. If the web post does not have a title, then it's a note.

If syndicating a note type of post to social media, such as Twitter, then brid.gy posts to Twitter the first X-number of characters of the Wren note.

If wanting to include a photo in a post that will be syndicated to social media, such as my Twitter account, then I need to add the following Microformat class attribute to the HTML image tag.

    <img class="u-photo" src="https://c1.staticflickr.com/5/4196/34898241830_4d5dc2af92.jpg" />

In the above example, I stored my image in my Flickr account, and I'm embedding the image into my web post that I want syndicated to Twitter. When using the `u-photo` class, the image appear in my Twitter feed.

When replying to another social media post, such as a tweet created by another user, I need to include the URL to the tweet that I'm replying to in my Wren post markup. The `u-in-reply-to` Microformat class attribute needs to be added to the HTML anchor tag.

    <a class="u-in-reply-to" href="https://twitter.com/jothut/status/878676037290385408"></a>




### Micropub

An author logs into a Micropub client, using IndieAuth. The client will search the author's homepage for the Wren website's Micropub endpoint and the token server used by the Wren site.

I choose to use a token server installed elsewhere. The token server is used to complete the IndieAuth login process, and the token is used to verify a login when creating and updating a post.

    <link rel="micropub" href="http://yourwebsite/api/v1/micropub" />
    <link rel="token_endpoint" href="https://tokens.indieauth.com/token" />


I have used the following Micropub clients to create posts at Wren that include new stand-alone posts, replies to other web posts, syndicated posts to Twitter, and replies to tweets by others.

* [Quill](https://quill.p3k.io) - web-based editor
* [Micropublish](https://micropublish.net) - web-based editor
* [Woodwind](https://woodwind.xyz) - web-based feed writer with reply capabilities
* [Omnibear](https://chrome.google.com/webstore/detail/omnibear/cjieakdeocmiimmphkfhdfbihhncoocn) - Chrome web browser extension

An author can create a web post on a Wren website by using email.

Quill provides an email address to an author. You have to log into Quill via IndieAuth to get the email address.

Within email, I leave the subject line blank, and I use Textile or Markdown markup within the body of the post. I put the title for the post within the email body.

After sending the email to Quill, the Quill service then accesses Wren's Micropub endpoint to make the post to the Wren website.

Unfortunately, the web post via email may not be formatted properly because of how some email systems break long lines into a series of lines that are at max approximately 80 characters long. 

Within the email client, I try to limit my line length with hard returns. That works for viewing the web post on a larger screen, but it wraps improperly, of course, when viewing the post on a small screen.

These two test posts contain info about posting to Twitter and creating a post from a Micropub client.

* [Posting to Twitter via brid.gy](http://wren.soupmode.com/posting-to-twitter-via-bridgy.html)
* [Now making a note post from Quill](http://wren.soupmode.com/now-making-a-note-post-from-the-quill-micropub-client-its-now-sat-jun-24.html)


*updated Sep 18, 2017*


