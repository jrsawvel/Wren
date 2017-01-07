# Wren API

In the Wren YAML config file `wren.yml`, an entry exists that specifies the API location:

`api_url  :  http://website/api/v1`

Only two actions exist: `users` and `posts`. These actions are appended to the above URL.

At the moment, Wren is a single-user publishing app. 



### USERS



#### Request Login Session Link

The author's email address is stored in the YAML file. To login, only the email address is provided. The Wren app uses the MailGun service to send the message that contains the login activation link.

This uses a POST request to `/users/login` that sends the following JSON:

    {
      "email" : "author.email.address", 
      "url"   : "http://website/nopwdlogin"
    }

The API code uses the value for `url` in the email message. Here's an example email that contains the login activation link:

> Subject: Wren Login Link - Fri, 08 Apr 2016 15:08:26 Z

> Clink or copy link to log into the site.

> http://website/nopwdlogin/hHggOD2q


Curl example:

    curl -X POST -H "Content-Type: application/json" --data '{ "email" : "author.email.address", "url" : "http://website/nopwdlogin"}' http://website/api/v1/users/login

... returned JSON ...

    {
        "status":200,
        "description":"OK",
        "session_id_digest":"hHggOD2q",
        "user_message":"Creating New Login Link",
        "system_message":"A new login link has been created and sent."
    }

The `session_id_digest` value is only included in the returned JSON when `debug_mode` equals `1` in the YAML config file. The `session_id_digest` value is included on the login link that is emailed to the author.

If the email address submitted does not match what exists within the YAML config file, then the following JSON is returned:

    {
      "status":"400",
      "description":"Bad Request",
      "user_message":"Invalid input.",
      "system_message":"Data was not found."
    }




#### Activate Login Session

This uses a GET request to `/users/login/?rev=[session_id_digest]`.

This activation process can occur only one time. A flag is set in the session ID file that prevents the login link from being used again.

`[session_id_digest]` is the alpha-numeric string attached to the end of the login link emailed above. 

This login activation process can occur only one time. A flag is set in the session file for this digest.

Curl example:

    curl http://website/api/v1/users/login/?rev=hHggOD2q

If the request to login is successful, then the API returns the following:

    {
      "status":200,
      "description":"OK",
      "author_name":"NickAdams",
      "rev":"hHggOD2q",
      "session_id":"kPavt87rPj49cvGZY8YHnQ"
    }

The `author_name`, `rev`, and `session_id` values are stored as cookies in the author's browser. This information is sent to the API for actions that require authentication.

If an attempt was made to activate a login session with the same link, the returned JSON would be:

    {
      "status":"400",
      "description":"Bad Request",
      "user_message":"Unable to login.",
      "system_message":"Invalid session information submitted."
    }




#### Logout

This uses a GET request:

    /users/logout/?author=[author_name]&session_id=[session_id]&rev=[rev]

Curl example:

    curl http://website/api/v1/users/logout/?author=NickAdams\&session_id=kPavt87rPj49cvGZY8YHnQ\&rev=hHggOD2q


Returned JSON if successful:

    {
      "status":200,
      "description":"OK",
      "logged_out":"true"
    }





### POSTS



#### Create a New Post

Uses a POST request to `/posts` with the following JSON being submitted as an example:

    {
      "author"      : "NickAdams", 
      "session_id"  : "kPavt87rPj49cvGZY8YHnQ", 
      "rev"         : "hHggOD2q",
      "submit_type" : "Create", 
      "markup"      : "# Test Post 8Apr2016 1113\n\nHello World"
    }

`submit_type` can be either `Create` or `Preview`.



Curl example for previewing a post:

    curl -X POST -H "Content-Type: application/json" --data '{"author": "NickAdams", "session_id": "kPavt87rPj49cvGZY8YHnQ", "rev":"hHggOD2q", "submit_type": "Preview", "markup": "# Test Post 8Apr2016 1113\n\nHello World"}' http://website/api/v1/posts


... returned JSON ...

    {
      "status":200,
      "description":"OK",
      "author":"NickAdams",
      "slug":"test-post-8apr2016-1113",
      "post_type":"article",
      "created_time":"15:13:20 Z",
      "created_date":"Fri, 08 Apr 2016",
      "title":"Test Post 8Apr2016 1113",
      "word_count":2,
      "reading_time":0,
      "toc":0,
      "html":"<p>Hello World</p>\n\n"
    }

If custom CSS was used in the markup, then the name-value `custom_css` along with the actual CSS is included in the returned JSON.

Create the new post with an incorrect `post_type`:

    curl -X POST -H "Content-Type: application/json" --data '{"author": "NickAdams", "session_id": "kPavt87rPj49cvGZY8YHnQ", "rev":"hHggOD2q", "submit_type": "Post", "markup": "# Test Post 8Apr2016 1113\n\nHello World"}' http://website/api/v1/posts


... returned JSON ...

    {
        "status":"400",
        "description":"Bad Request",
        "user_message":"Unable to process post.",
        "system_message":"Invalid submit type given."
    }


Create the post:

    curl -X POST -H "Content-Type: application/json" --data '{"author": "NickAdams", "session_id": "kPavt87rPj49cvGZY8YHnQ", "rev":"hHggOD2q", "submit_type": "Create", "markup": "# Test Post 8Apr2016 1113\n\nHello World"}' http://website/api/v1/posts

... returned JSON ...

    {
      "status":200,
      "description":"OK",
      "author":"NickAdams",
      "title":"Test Post 8Apr2016 1113",
      "post_type":"article",
      "created_date":"Fri, 08 Apr 2016",
      "created_time":"15:17:06 Z",
      "word_count":2,
      "reading_time":0,
      "html":"<p>Hello World</p>\n\n","toc":0,"slug":"test-post-8apr2016-1113"
    }


`/links.json` will contain the new post at the top of the file. Other files updated after a "Create" include `/rss.xml`, `/sitemap.xml`, and `/mft.html`.

At the moment, no files are updated when an existing post is modified.


Create a new post that gets stored in a subdirectory:

    curl -X POST -H "Content-Type: application/json" --data '{"author": "NickAdams", "session_id": "kPavt87rPj49cvGZY8YHnQ", "rev":"hHggOD2q", "submit_type": "Create", "markup": "# Test Post 8Apr2016 1130\n\nHello World\n\n<!-- dir : 2016/04/08 -->"}' http://website/api/v1/posts

... returned JSON ...

    {
      "status":200,
      "description":"OK",
      "author":"NickAdams",
      "title":"Test Post 8Apr2016 1130",
      "slug":"test-post-8apr2016-1130",
      "dir":"2016/04/08",
      "post_type":"article",
      "created_date":"Fri, 08 Apr 2016",
      "created_time":"15:30:30 Z",
      "reading_time":0,
      "word_count":2,
      "toc":0,
      "html":"<p>Hello World</p>\n\n<!-- dir : 2016/04/08 -->\n\n"
    }

When a post is to be stored in a sub-directory, then the `dir` name-value gets returned.



#### Read the Markup for a Post

This uses a GET request to `/posts/[page_id]` where page_id equals the slug.

If the HTML page was found at http://website/test-post-8apr2016-1113.html then a Curl example to retrieve this post's markup would be:

    curl http://website/api/v1/posts/test-post-8apr2016-1113

... returned JSON ...

    {
      "status":200,
      "description":"OK",
      "slug":"test-post-8apr2016-1113",
      "markup":"# Test Post 8Apr2016 1113\n\nHello World\n"
    }

If the post does not exist, then the returned JSON would be:

    {
      "status":"400",
      "description":"Bad Request",
      "user_message":"[1] Could not read test-post-whatever.txt.",
      "system_message":"File not found."
    }

If the post was stored in a sub-directory, then the request would be:

    curl http://website/api/v1/posts/2016/03/30/cold-temps-expected-during-the-first-week-of-april-2016.html

The extension `.html` is optional. If it exists, then the API code ignores it.

Within the returned JSON, `slug` may be a misnomer, since in the above example, `slug` equals `2016/03/30/cold-temps-expected-during-the-first-week-of-april-2016`. 

Technically, the slug would be the text that follows the last forward slash. But I permitted this exception to allow storing posts in sub-directories. 

It's also possible to ignore the API code and access the `.txt` version of a post under document root, which contains the markup. Working examples:

* HTML = <http://wren.soupmode.com/info.html>
* Markup = <http://wren.soupmode.com/info.txt>






#### Update a Post

Uses a PUT request to `/posts`.

    {
      "author"        : "NickAdams", 
      "session_id"    : "kPavt87rPj49cvGZY8YHnQ", 
      "rev"           : "hHggOD2q",
      "submit_type"   : "Update",
      "original_slug" : "test-post-8apr2016-1130", 
      "markup"        : "# Test Post 8Apr2016 1130\n\nHello World\n\nline added in update\n\n<!-- dir : 2016/04/08 -->"
    }

`submit_type` can be either `Update` or `Preview`.


Curl example:

    curl -X PUT -H "Content-Type: application/json" --data '{"author": "NickAdams", "session_id": "kPavt87rPj49cvGZY8YHnQ", "rev":"hHggOD2q", "submit_type": "Update", "markup": "# Test Post 8Apr2016 1130\n\nHello World\n\nline added in update\n\n<!-- dir : 2016/04/08 -->", "original_slug":"test-post-8apr2016-1130"}' http://website/api/v1/posts


If successful, the returned JSON would be:

    {
      "status":200,
      "description":"OK",
      "author":"NickAdams",
      "title":"Test Post 8Apr2016 1130",
      "original_slug":"test-post-8apr2016-1130",
      "slug":"test-post-8apr2016-1130",
      "dir":"2016/04/08",
      "post_id":"2016/04/08/test-post-8apr2016-1130",
      "post_type":"article",
      "created_date":"Fri, 08 Apr 2016",
      "created_time":"15:40:40 Z",
      "reading_time":0,
      "word_count":6,
      "toc":0,
      "html":"<p>Hello World</p>\n\n<p>line added in update</p>\n\n<!-- dir : 2016/04/08 -->\n\n",
}

If custom CSS was used in the markup, then the name-value `custom_css` along with the actual CSS is included in the returned JSON.

The `post_type` is a holdover from another app. Currently, all Wren posts are considered to be "articles", which means the `post_type` is unnecessary. My other web publishing apps differentiated between "articles" and "notes". The key difference being that "notes" did not have a title.



### SEARCHES

This uses a GET request to `/searches/[string]`

Curl example:

    curl http://website/api/v1/searches/user+guide

Returned JSON:

    {
      "status":200,
      "description":"OK",
      "search_text":"user guide",
      "total_hits":3,
      "posts":[
        {
          "url":"http://website/tag-wren.html",
          "uri":"tag-wren"
        },
        {
          "url":"http://website/index.html",
          "uri":"index"
        },
        {
          "url":"http://website/wren-user-guide.html",
          "uri":"wren-user-guide"
        }
      ]
    }


### WEBMENTIONS

This is a new take on trackback, pingback, and commenting. It's described at <https://indieweb.org/Webmention>.

This uses a POST request to `/webmentions`

JSON is NOT sent to the API endpoint. The POST request is `application/x-www-form-urlencoded`.

In this curl example, `targetsite.com` is the Wren-powered website. "Source" refers to the website that created the reply or comment post. The reply post on the source site must contain the link of the post at the target site that is being replied to.

    curl -i -d "source=http://sourcesite.com/test-webmention-reply-post.html&target=http://targetsite.com/in-2016-digital-publishers-are-finally-concerned-about-ux.html" http://targetsite.com/api/v1/webmentions

The API, however, always returns JSON, according to the information at <https://webmention.net/draft>

