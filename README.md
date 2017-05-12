# Wren README

### Brief Description

* Built with Perl and HTML::Template
* API-based, using REST and JSON.
* No database.
* Single-user mode only.
* Logging in only requires an email address. A password is never used.
* Markup support: Markdown, Multimarkdown, Textile, and HTML. 
* Additional custom commands exist to control formatting and functionality of a post. 
* Simple and enhanced writing areas.
* Content headers can be used to create a table of contents for the page. 
* RSS feed for posts sorted by created date.
* Responsive web design.
* Client-side JavaScript is used only with the editor.
* Reading time and word count are calculated for each post.
* The author has a lot of freedom.
* Optionally, the .html and .txt files can be copied to an AWS S3 bucket.
* Accepts the Indieweb.org's version of pingback or replies, called Webmentions.
* An optional login method exists that uses the Indieweb.org's IndieAuth.


### Longer Description

Wren is a web-based, static site, blog tool that does not use a database. 

Wren requires the user to create most of the functions that would be automatically created in most "normal" web publishing apps.

For example, the homepage is not automatically generated. The index.html files that are located in the root directory and in sub-directories get created and updated like a regular article post.

The same applies to archives and tag-related pages. My other web publishing apps automatically support hashtag searches. Not wren. The Wren author must create the hashtag links the HTML pages for each tag. And the author must add the link to the post to each tag-related page.

It's a slower way to produce content, which may mean staying more focused and writing when having something important to create, instead of saving and commenting on every link encountered. And I like the freedom of a blank canvas with minimal constraints.

Wren posts can be created and updated through a web browser on a desktop/laptop or on a mobile device. 

Wren has an API, which can be accessed with command prompt utilities or [curl](https://curl.haxx.se/). The Wren API doc describes how to use it. I'll need to finish creating the example command prompt utility, and I need to enable the API to support "Preview" when access has no authentication. Preview will return the formatted post, which could be saved on a local hard drive. 

When logging into a Wren site, it uses a no-password login mechanism. The author submits an email address, and the login activation link is emailed to the address listed within the Wren YAML configuration file. The app uses [MailGun](http://www.mailgun.com/) to send these emails.

In the spring of 2017, I added an optional login method that uses  [IndieAuth](http://indieweb.org/IndieAuth). It's possible to setup an individual IndieAuth server, but my Wren code relies on [indieauth.com](http://indieweb.org/indieauth.com). 

To login via IndieAuth, a website's homepage URL is entered. It could be the URL of the website that is powered by Wren, or it can be another website. But the website must be owned by the author. The author must also possess an account at a popular service, such as GitHub, Twitter or Google. The full explanation for using IndieAuth and how it works can be found at the above links. 
 
With Wren, text can be formatted using [Markdown](https://daringfireball.net/projects/markdown/) and HTML commands. Actually, Wren supports MultiMarkdown, which means being able to create tables, footnotes, definition lists, and more. 

In the spring of 2017, I added [support](http://toledotalk.com/cgi-bin/tt.pl/article/37/Textile) for [Textile](http://toledotalk.com/cgi-bin/tt.pl/article/63/Textile_quick_reference). For my newer websites, I write in Markdown. For my older websites, I write in Textile. I've been writing in Textile, since 2005. I want to import old Textile-based content into a Wren-powered website.

In recent years, I've tried to minimize the formatting that I do for a web article. Keep it simple. And Markdown satisfies my needs, nearly all of the time.

To allow comments, Wren supports the Indieweb.org's [Webmention](http://indieweb.org/Webmention) protocol. This is an optional setup. Wren displays Webmentions in two different styles. More information can be found in the Wren document about Webmentions.

These are my test Wren sites that use a combination of new posts and posts that I created elsewhere in the past:

* <http://wren.soupmode.com>
* <http://zwdqwr2p2xwkpbyv.onion>

The .onion site is running on my Linux computer inside our home, provided that the computer is powered on. I installed the Tor server. The localhost site is powered by Nginx and Wren, which creates the HTML pages. Then I copy the HTML content to the location of the .onion site, which uses thttpd to serve the pages. I did this for testing.

In September 2016, created a new Wren-powered site at <http://boghop.com> to host some of the web content that I have created since 2001. It will take a long time to get things copied. 

In 2014, I used my Grebe publishing app to manage our home beer brewing blog at <http://birdbrainsbrewing.com>. But in the spring of 2016, I switched to using Wren. Much of the content had to be converted from Textile to Markdown.

For search, Google and/or DuckDuckGo can be used, but I rely mainly on Wren's simple, built-in search mechanism. At the moment, the search forms are manually setup by creating an HTML page like any other article. The Wren User Guide doc contains the HTML code that can be used for a search page. I should  make this its own template.

When logged into Wren through a web browser, the author enters the commands in the URL after the site's domain name.

* `/wren/create`
* `/wren/update/file.html` 
* or `/wren/update/2016/03/24/file.html`
* `/wren/login`
* `/wren/logout`


Special formatting commands can be used within HMTL comments in the markup. The info is contained within the User Guide.

The Wren Markdown is lightly flavored.


