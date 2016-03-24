# Wren 

Wren is a web-based, static site, blog tool. It requires the user to create most of the functions that would be automatically created in "normal" web publishing apps.

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

For search, I will rely on using Google and/or DuckDuckGo.

I need to add support for writing with the JavaScript editor that I have enabled with my other web publishing apps.

To access the markup text version of a post, replace `.html` at the end of the URL with `.txt`.

Wren maintains a list of all links to posts in a file called `links.json`. Wren uses this file to create `rss.xml`, `sitemap.xml`, and `mft.html`. 

`mft.html` lists the most recent posts in an HTML file that uses [microformats](http://microformats.org/wiki/microformats2). Some [Indieweb users](https://indiewebcamp.com/) prefer to syndicate their content by marking up their HTML files with microformats. Parsers would read a user's homepage to create a feed to be read by someone else, instead of accessing the author's RSS feed.

When logged into Wren through a web browser, the author enters the commands in the URL after the site's domain name.

* `/wren/create`
* `/wren/update/file.html` 
* or `/wren/update/2016/03/24/file.html`
* `/wren/login`
* `/wren/logout`


In the Wren YAML configuration file, the following directories need to be specified. The first two should be created outside of document root.

*  `markup_storage : /home/wren/markup` - for easy download, backup
*  `session_id_storage : /home/wren/sessionids`
*  `versions_storage : <html doc root>/versions`


Special Wren commands are listed within HMTL comments in the markup.

* `<!-- toc : yes -->` - create a table of contents. default is NO.
* `<!-- slug : slugname -->` - example for the homepage = `slug:index`
* `<!-- dir:directory-location -->` - example = `dir:2006/03/24`
     
I need to add the `<!-- template : name -->` command in case I want a particular post to use a custom formatting template that's different than the default.

For my other web publishing apps, such as Junco, Grebe, Scaup, and Veery, I created many custom formatting commands. But at the moment, Wren only uses two.

* `br.` - to force a break or a blank line. 
* `fence. fence..` - to be used around a large code block when indenting each line with four spaces is tedious.



