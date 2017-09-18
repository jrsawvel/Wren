# Wren Webmention

A Webmention is similar to the old trackback or pingback that some blog sites used back in the aught years. It permits cross-site communication. Instead of commenting directly on other websites, users create their replies on their own websites, and then either manually or programmatically, their replies are posted to the sites that are suppose to receive the replies. This process is called Webmention.

* <https://indieweb.org/Webmention>
* <https://webmention.net/draft>


### Receiving Webmentions

#### Programmatically

Wren provides a Webmention API endpoint at `/webmention`, which can be used by other content management systems to post Webmentions to Wren-powered websites. 

A person could also use the cURL command-line utility to post a Webmention manually to Wren's Webmention endpoint. 

The endpoint needs to exist within the `<head>` section of the HTML page for the Wren site's homepage. Example:

    <link rel="webmention" href="http://wren-website/api/v1/webmentions" />

When other web publishing systems support sending Webmentions, those other apps will parse the Wren site's homepage, looking for Wren's Webmention endpoint. 



#### HTML form

If commenters use a web publishing system that does not support the sending of Webmentions, then Wren provides the option for commenters to copy and paste the URLs to their reply posts into a web form at Wren sites.

The webpage that will contain the HTML form elements to permit reception of Webmentions is listed in the Wren YAML config file. Example: webmentions.txt. The Wren site owner then creates the web page like any other web post that's created through Wren.

The following HTML should be added to this page:

    <form markdown="1" action="/wren/webmention" method="post">
    **source url** (your reply post): 
    <input size=31 type=text name="source">
    **target url** (Wren post that you're replying to): 
    <input size=31 type=text name="target">
    <input class="submitbutton" type=submit name=sb value="Post Webmention"></form>


My current Wren setup manually accepts Webmentions differently than most IndieWeb website owners. In this setup, the commenter must also provide the URL of the Wren post being replied to.

Instead of displaying the replies on each intended page, all of the replies are displayed on this one page. It's a crude setup for now, and maybe it will be changed to display comments (Webmentions) at the bottom of each web post like normal comments.

For the current Wren Webmention setup, links get inserted into the .txt file listed in the YAML file, and the HTML page gets rebuilt automatically by the Wren code. But the site owner can edit the page, like any other Wren post, and the site owner can moderate out (delete) any unacceptable posts. The site owner can split the Webmentions across multiple pages if the main page gets too big.

By default, the Webmentions info will get inserted into the .txt file from oldest to youngest. To reverse the list of Webmentions from youngest to oldest by date, then add the comment line `<!-- insert -->` to the .txt file, possibly  below the text input fields, shown above. The new Webmention will be added below the insert comment line, and then the rest of the Webmentions will follow in the youngest to oldest order.



### Using 3rd Party Service to Receive Webmentions

Create an account at:<https://webmention.herokuapp.com> - 

The endpoint is: <https://webmention.herokuapp.com/api/webmention>

curl example:

    curl -i -d "source=http://elsewhere.com/a-reply-post.html&target=http://wren-site.com/my-opinion-about-something.html" https://webmention.herokuapp.com/api/webmention


Wren does not provide an easy manual way for someone to post a Webmention to the above service. It's meant to be used programmatically by web publishing systems that support the automatic sending of Webmentions. The webmention.herokuapp API endpoint would need to be included in the Wren site's homepage.

This service would be used to accept and display Webmentions on individual pages like normal comment systems.

To enable Webmentions to appear at the bottom of an individual page, using the above service, the following would need to be added to the Wren post.

    <!-- template : webmention -->

The Wren Webmention template contains the CSS and the JavaScript to display Webmentions for the article that are stored at the above third party service.



### Sending Webmentions

Wren can automatically send a Webmention reply post to another website by including the URL of the post being replied to in this custom Wren command:

    <!-- reply_to : URL -->

Wren will parse that URL to get the domain name. Wren will retrieve the other website's homepage, looking for the Webmention endpoint if it exists. 

If the endpoint exists, Wren sends or posts the Webmention response. It's up to other site owner to decide how to process and display Webmentions. Some users will moderate their Webmentions, which means the replies will not appear immediately. 

Some users display the entire contents of the Webmention reply, including all HTML formatting, while other users display a snippet of the Webmention reply post with HTML formatting removed, but a link the Wren site post would be included at the other user's website.

When replying to someone else's site that accepts Webmentions, it might be worthwhile to add the following microformat around the opening paragraph of a reply (Webmention) post.

    <span class="p-summary">This might be the opening paragraph in my Webmention post that is reply to a post on another website.</span>

At the moment, Wren sends Webmentions only on creates and not updates.

And at the moment, Wren sends only one Webmention per created post. Some IndieWeb users have their CMS apps setup to send a Webmention to EVERY link mentioned in each post.




### Integrating with Social Media

#### Syndication

As an option, Wren uses a third party service called [brid.gy](https://brid.gy) to syndicate posts to social media services.

To syndicate, the following command must be added to the markup of a Wren post. In this example, the post will be syndicated to Twitter.

    <!-- syn_to : twitter -->

At brid.gy, I would "register" my Twitter account and associate it with my Wren website.

Wren makes a Webmention post to brid.gy. This cURL example helps explain it.

    curl -d 'source=http://wren-website/hello-world.html&target=http://brid.gy/publish/twitter' https://brid.gy/publish/webmention


Before Wren makes the Webmention post to brid.gy, Wren tacks onto the end of the markup for the post the following HTML comment. 

    <!-- bridghy_target_url_twitter : http://brid.gy/publish/twitter -->

The URL must be included in the post to make the Webmention post to brid.gy work. 

**I don't know why I start the command with "bridghy", which appears to be a misspelling.**


After posting a Webmention to brid.gy, my Wren post would appear as a link in my Twitter account. The link, of course, points back to the post at the Wren site. 

If title text exists for the Wren post, then that text will also appear in the tweet because the Microformat class `p-name` was used with the `h1` tag.

Example: 

    <h1 class="p-name">Posting to Twitter via Brid.gy</h1>

In the IndieWeb world, an article is defined as a post that has a title. If the web post does not have a title, then it's a note type of post.

If syndicating a note type of post to social media, such as Twitter, then brid.gy posts to twitter the first X-number of characters of the Wren note post



#### Posting an image

The photo must already exist somewhere. For me, that would mean uploading the photo to either my Flickr account or to my own home-grown image uploading web site. 

But that's a common way for me to handle photos. When I create web posts that contain images, the images are usually stored elsewhere, and I embed them into my web posts, using the HTML `img` tag or more likely by using the image commands associated with the Markdown and Textile markup languages.

Some CMS apps permit uploading of the image at about the same time as creating the web post. Wren does not support file uploading.

To syndicate an image to Twitter, I use the HTML image tag to embed the image, and I attach the `u-photo` Microformat class.

Here's an example Wren note-type of post:

    this test post will attempt to post a photo to my twitter account. the photo is of my garden from 2014. i'm posting a small version of the photo that's stored in my flickr account. 
    
    <img class="u-photo" src="https://c1.staticflickr.com/5/4196/34898241830_4d5dc2af92.jpg" />
    
    <!-- syn_to : twitter -->

The photo appears in the tweet along with the first X-number of chars from the note type of post. A link to the post at the Wren site is also included in the tweet. 

Real-world example: [sawv.org web post](http://sawv.org/2017/08/19/homecooked-dinner-sat-aug-19-2017.html) that contained a photo, and the post was syndicated to the jr_sawv Twitter account. Here's the [tweet](https://mobile.twitter.com/jr_sawv/status/902291439840890880?p=p).




#### Backfeeding

If another user at the social media service interacts with my syndicated post at that social media service, then brid.gy gets the activity and forwards it on to the Wren website as a Webmention. Wren receives a  Webmention that points to someone's reply, share, like, etc. that was created at the social media site.

Most IndieWeb users display these social media interactions as comments at the bottom of the personal website pages that were syndicated to social media. 

At first glance of a user's personal website, it appears that people posted comments directly at the bottom of the user's post on the user's website. But instead, the commenters replied at Twitter or on their own websites. Everything came back to the author's website as Webmentions.

But at the moment, I have Wren configured to display all received Webmentions on one Wren web page. 

Example: If I syndicate a Wren post to Twitter, and another Twitter user replies on Twitter, brid.gy posts that info to Wren as a Webmention, and Wren displays the link to the reply tweet on Wren's Webmention page.

Here's an example [Webmention backfeeding post from Twitter via brid.gy](https://brid-gy.appspot.com/comment/twitter/pondhawk/878465497116835840/878677494861357060).

Personal website owners can parse the HTML backfeeding post from brid.gy and display the "comment" on the owners' websites however the owners desire.

It might seem a little confusing because of brid.gy acting like a middleman between a personal website and a social media site.



#### Replying to a social media post

[This test web post of mine](http://wren.soupmode.com/going-down-deeper-into-the-rabbit-hole-test-post-24jun2017-1422-attempti.html) is meant to be a reply to someone else's Twitter post.

My Twitter reply wren post needs to include the URL of the tweet being replied to. Here's some example Wren markup:

    <!-- syn_to : twitter -->
    
    <a class="u-in-reply-to" href="https://twitter.com/jothut/status/878676037290385408"></a>


Wren, of course, makes the Webmention post to brid.gy.  Since brid.gy knows that my Wren site is associated with my Twitter account, and since brid.gy sees the `u-in-reply-to` Microformat class in my post, then brid.gy syndicates my Wren post to Twitter as a reply tweet to someone else's tweet.

It's faster and easier to use Twitter's native app on the phone to create tweets and to reply to existing tweets, but the IndieWeb approach makes it possible to create, read, and reply from a person's own website, which means the person owns the content, including the replies from others, which does seem a bit strange. I'm surprised that Twitter and Facebook permit the backfeeding behavior. 



*updated Sep 6, 2017*


