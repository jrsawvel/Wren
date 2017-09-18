# Wren README

### Brief Description

* Built with Perl and HTML::Template
* API-based, using REST and JSON.
* No database.
* Single-user mode only.
* Logging in only requires an email address. A password is never used.
* An additional no-password login method exists that uses the Indieweb.org's IndieAuth, which requires entering a personal domain name that's tied to a service, such as GitHub or Twitter.
* Markup support: Markdown, Multimarkdown, Textile, and HTML. 
* Additional custom commands exist to control formatting and functionality of a post. 
* Simple and enhanced writing areas.
* Content headers can be used to create a table of contents for the page. 
* RSS feed for posts sorted by created date.
* JSON feed for posts sorted by created date. The format is based upon the [Reece-Simmons spec](https://jsonfeed.org).
* HTML feed or h-feed page exists that is marked up with Microformats, according to the IndieWeb h-entry spec.
* Responsive web design.
* Client-side JavaScript is used only with the editor.
* Reading time and word count are calculated for each post.
* The author has a lot of freedom for customizing web posts, since custom CSS can be added.
* Optionally, Wren can automatically copy the .html and .txt files to an AWS S3 bucket after creates and updates.
* Accepts the IndieWeb.org's version of pingback or replies, called Webmentions.
* Sends Webmention replies to other websites.
* Supports the IndieWeb Micropub spec on the server, which permits creating posts by using Micropub-supported clients, created by others.
* Additional Microformats are used, according to IndieWeb concepts.


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

When Wren creates a new post, Wren automatically generates a sidefile page called mft.html that is an HTML feed or [h-feed](http://microformats.org/wiki/h-feed) page, based upon the [Microformat](http://microformats.org/) ideas, suggested by the IndieWeb, specifically [h-entry](http://indieweb.org/h-entry).

The web-based feed reader [woodwind.xyz](https://woodwind.xyz) supports consuming RSS and Atom feeds. But Woodwind also supports consuming the h-feed format. 

If a website organizes content from youngest to oldest, which can be the homepage or a sidefile page that supports h-entry Microformats, then that HTML page can be submitted as the feed page to Woodwind. 

Instead of creating RSS, Atom, or JSON feed pages, a website only has to add Microformats to its already existing HTML stream page, which is the hompage for many blog sites. But at the moment, the only feed reader that can read an h-feed is Woodwind. 

To allow comments, Wren supports the Indieweb.org's [Webmention](http://indieweb.org/Webmention) protocol. This is an optional setup. Wren displays Webmentions in two different styles. More information can be found in the Wren document about Webmentions.

Wren can also send Webmentions to sites that support the Webmention protocol. A special command is added to the markup page that tells Wren where to send the Webmention. According to the protocol, Wren will search the other website's homepage for the site's Webmention endpoint, and then Wren sends the Webmention.

Wren supports the IndieWeb's [Micropub spec](https://indieweb.org/micropub) on the server. This means that posts can be created by using Micropub clients created by other developers. The Micropub clients require logging in via IndieAuth, which means the author enters his or her personal website. The Wren Micropub endpoint must be listed in the homepage for the Wren site. This is used by the Micropub client. 

I've created Wren posts by using Micropub clients, such as [Quill](https://quill.p3k.io/) and [Micropublish](https://micropublish.net), which are web-based. 

The web-based feed reader [woodwind.xyz](https://woodwind.xyz) supports the Micropub client spec. That means a user can read other websites in the Woodwind feed reader and then create a reply post from within Woodwind. Woodwind will use Micropub to create the post at the Wren website, and then Wren will send the Webmention to the site being replied to.

The Chrome web browser extension called Omnibear supports the Micropub client spec. A user logs into the Omnibear extension by using IndieAuth. When reading a website, a user can click the browser extension icon from the URL bar, which causes a small dialog box to pop-up. The user can reply to the website with Omnibear, which creates the post at the Wren website by using Micropub, and then the Wren website send the Webmention to the site being replied to. 

These are my test Wren sites that use a combination of new posts and posts that I created elsewhere in the past:

* <http://wren.soupmode.com>
* <http://zwdqwr2p2xwkpbyv.onion>
* [gopher://sawv.org](gopher://sawv.org)

The .onion site is running on my Linux computer inside our home, provided that the computer is powered on. I installed the Tor server. The localhost site is powered by Nginx and Wren, which creates the HTML pages. Then I copy the HTML content to the location of the .onion site, which uses thttpd to serve the pages. I did this for testing.

The gopher site is powered by the Bucktooth server. The HTML pages were created with Wren code and then copied to the root directory for the gopher server. The gopher-formatted text pages, however, were created manually. For some reason, gopher clients, such as the Overbite Firefox extension and the iGopher app for the iPhone support the rendering of HTML pages. Gopher uses its own plain text format. It would be interesting to modify Wren to convert Markdown/Textile markup to gopher plain text markup. I don't think that HTML pages should served over gopher.

In 2014, I used my Grebe publishing app to manage our home beer brewing blog at <http://birdbrainsbrewing.com>. But in the spring of 2016, I switched to using Wren. Much of the content had to be converted from Textile to Markdown.

In September 2016, I created a new Wren-powered site at <http://boghop.com> to host some of the web content that I have created since 2001. It will take a long time to get things copied. But in August 2017, I copied boghop.com content to my new website <http://sawv.org>, which I hope will host all of my web content since 2001.

For search, Google and/or DuckDuckGo can be used, but I rely mainly on Wren's simple, built-in search mechanism. At the moment, the search forms are manually setup by creating an HTML page like any other article. The Wren User Guide doc contains the HTML code that can be used for a search page. I should  make this its own template.

My boghop.com setup relied on Amazon Web Services. I used two domain names though. I used Route 53 to manage DNS. I pointed boghop.net to an Ubuntu Linux EC2 server instance, which hosted my Wren code. Creates and updates had to use the boghop.net domain. When a post was created and updated, Wren copied the .txt and .html files to an S3 bucket. I cached pages with CloudFront, but only for five minutes. 

I pointed boghop.com to the CloudFront cache. Within AWS, I had CloudFront pointing to the S3 bucket. If a page request was not found in cache, then the page got served from S3 and then cached. Obviously, this is unnecessary, but I wanted to learn more about AWS services. More info about this setup can be found on [my post here.](http://sawv.org/boghopcom-tech-stack.html).

When logged into Wren through a web browser, the author enters the commands in the URL after the site's domain name.

* `/wren/create`
* `/wren/update/file.html` 
* or `/wren/update/2016/03/24/file.html`
* `/wren/login`
* `/wren/logout`


Special formatting commands can be used within HMTL comments in the markup. The info is contained within the User Guide.

The Wren Markdown is lightly flavored.

*updated Sep 6, 2017*

