# Wren API


### Read the markup for a single post

This uses a GET request to `/posts/[page_id]` where page_id = the slug or the part of the URI that precedes the `.html` for a post.

Example: http://wren.soupmode.com/info.html

Retrieve the `info.html` markup:
    
    curl http://wren.soupmode.com/api/v1/posts/info

Returned JSON:

    {
      "status":200,
      "description":"OK",
      "slug":"info",
      "markup":"# Info\r\n\r\n* [Tags](/tags.html)\r\n* [RSS feed](/rss.xml)\r\n* [JSON feed](/links.json)\r\n* [Sitemap XML](/sitemap.xml)\r\n* [Microformatted List of Posts](/mft.html)\n"
    }

If the post was stored in a sub-directory, then the request would be like this example:

    curl http://wren.soupmode.com/api/v1/posts/2016/03/30/cold-temps-expected-during-the-first-week-of-april-2016.html

The extension `.html` is optional. If it exists, the API code ignores it.

