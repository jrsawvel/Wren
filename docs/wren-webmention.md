# Wren Webmention

<https://indieweb.org/Webmention>

<https://webmention.net/draft>


### Page to Accept Webmentions

This setup displays all webmentions that are posted to all posts on the wren site. Instead of displaying the replies on each intended page, all of the replies are displayed on this one page.

The page is simply another Wren post. The .txt version is listed in the YAML file. Example: webmentions.txt

The site owner must use Wren to create a post titled Webmentions. Wren will create the .html and .txt files as normal.

Webmention links get inserted into the .txt file, and the HTML page gets rebuilt. But the site owner can edit the page, like any other Wren post, and the site owner can moderate out (delete) any unacceptable posts. The site owner can split the webmentions across multiple pages if the main page gets too big.

By default, the webmentions info will get inserted into the .txt file from oldest to youngest. To reverse the list of webmentions from youngest to oldest by date, then add the comment line `<!-- insert -->` to the .txt file, possibly  below the text input fields, shown below. The new webmention will be added below the insert comment line, and then the rest of the webmentions will follow in the youngest to oldest order.

Include the following HTML into the webmentions page that's associated with the file mentioned in the YAML file or in another post:

    <form markdown="1" action="/wren/webmention" method="post">
    **source url** (your reply post): 
    <input size=31 type=text name="source">
    **target url** (Wren post that you're replying to): 
    <input size=31 type=text name="target">
    <input class="submitbutton" type=submit name=sb value="Post Webmention"></form>

Those text input fields allow a user to provide the URL to the user's reply post on his or her own site. But the commenter must also provide the URL of the Wren post being replied to.



### Using 3rd Party Service to Accept Webmentions

Create an account at:<https://webmention.herokuapp.com> - 

The endpoint is: <https://webmention.herokuapp.com/api/webmention>

curl example:

    curl -i -d "source=http://elsewhere.com/a-reply-post.html&target=http://wren-site.com/my-opinion-about-something.html" https://webmention.herokuapp.com/api/webmention


Wren does not provide an easy way for someone to post a Webmention to the above service.

This service would be used to accept and display webmentions on individual pages.

To enable Webmentions to appear at the bottom of an individual page, using the above service, the following would need to be added to the Wren post.

    <!-- template : webmention -->

The Wren Webmention template contains the CSS and the JavaScript to display Webmentions for the article that are stored at the above third party service.



### Replying to Another Site

Sending or posting a Webmention (reply post created with Wren) to another website.

Currently, Wren does not automatically send Webmentions to another site's Webmention endpoint. The other site would need to offer a text input field where the source URL could be pasted. Or `curl` would have to be used from the command prompt.

When replying to someone else's site that accepts Webmentions, it might be worthwhile to add the following microformat around the opening paragraph of a reply (Webmention) post.

    <span class="p-summary">This might be the opening paragraph in my Webmention post that is reply to a post on another website.</span>



