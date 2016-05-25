# Wren User Guide


The commands below will follow `http://yourdomain`.



### Login

Wren is a single-user app. No account creation process exists, and Wren uses a no-password login mechanism. 

To receive the login activation link, a user visits `/wren/login` and enters the email address stored in the Wren YAML configuration file.

If the email address entered matches, then Wren sends a message that contains the login activation link.

The login link can be used only one time. The link contains session information related to the login.



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

Wren contains one special formatting command:

* `fence. fence..` - to be used around a large code block when indenting each line with four spaces is tedious.

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

CSS can be included, which can override the default CSS or to add new display options.

To use custom CSS in a post, do the following:

    <!-- css_start 
    body {background: yellow;}
    css_end --> 

The starting and ending comment lines must occur at the beginning of a line.



### Files

To access the markup text version of a post, replace `.html` at the end of the URL with `.txt`.

Wren maintains a list of all links to posts in a file called `links.json`. Wren uses this file to create `rss.xml`, `sitemap.xml`, and `mft.html`. 

`mft.html` lists the most recent posts in an HTML file that uses [microformats](http://microformats.org/wiki/microformats2). Some [Indieweb users](https://indiewebcamp.com/) prefer to syndicate their content by marking up their HTML files with microformats. Parsers would read a user's homepage to create a feed to be read by someone else, instead of accessing the author's RSS feed.



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


