# Wren README

### Brief Description

* Built with Perl and HTML::Template
* API-based, using REST and JSON.
* No database.
* Single-user mode only.
* Logging in only requires an email address. A password is never used.
* Markup support: Markdown, Multimarkdown,  and HTML. 
* Additional custom commands exist to control formatting and functionality of a post. 
* Simple and enhanced writing areas.
* Content headers can be used to create a table of contents for the page. 
* RSS feed for posts sorted by created date.
* Responsive web design.
* Client-side JavaScript is used only with the editor.
* Reading time and word count are calculated for each post.
* The author has a lot of freedom.


### Longer Description

Wren is a web-based, static site, blog tool that does not use a database. 

Wren requires the user to create most of the functions that would be automatically created in most "normal" web publishing apps.

For example, the homepage is not automatically generated. The index.html files that are located in the root directory and in sub-directories get created and updated like a regular article post.

The same applies to archives and tag-related pages. My other web publishing apps automatically support hashtag searches. Not wren. The Wren author must create the hashtag links the HTML pages for each tag. And the author must add the link to the post to each tag-related page.

It's a slower way to produce content, which may mean staying more focused and writing when having something important to create, instead of saving and commenting on every link encountered. And I like the freedom of a blank canvas with minimal constraints.

Wren posts can be created and updated through a web browser on a desktop/laptop or on a mobile device. 

Wren has an API, which can be accessed with command prompt utilities or [curl](https://curl.haxx.se/). I'll need to finish creating the example command prompt utility, and I need to enable the API to support "Preview" when access has no authentication. Preview will return the formatted post, which could be saved on a local hard drive.

When logging into a Wren site, it uses a no-password login mechanism. The author submits an email address, and the login activation link is emailed to the address listed within the Wren YAML configuration file. The app uses [MailGun](http://www.mailgun.com/) to send these emails.

Text can be formatted using [Markdown](https://daringfireball.net/projects/markdown/) and HTML commands. Actually, Wren supports MultiMarkdown, which means being able to create tables, footnotes, definition lists, and more. 

Wren does not support Textile. That's a deviation from my other web publishing apps, especially since I have used Textile for writing since 2005. But within one of my Grebe-based web sites, I've tried to use Markdown more, and I've tried to minimize the formatting that I do. Keep it simple.

Here's a test Wren site that uses posts that I created elsewhere in the past:

* <http://wren.soupmode.com>

I'm also using Wren to store updates about my Dad's cancer treatment at:

* <http://dad.soupmode.com>

I use my Grebe publishing app to manage our home brewing blog at <http://birdbrainsbrewing.com>. I'm testing Wren by migrating content from that site into <http://beer.soupmode.com>. 

For search, I will rely on using Google and/or DuckDuckGo.

When logged into Wren through a web browser, the author enters the commands in the URL after the site's domain name.

* `/wren/create`
* `/wren/update/file.html` 
* or `/wren/update/2016/03/24/file.html`
* `/wren/login`
* `/wren/logout`


Special formatting commands can be used within HMTL comments in the markup.

The Wren Markdown is lightly flavored.

