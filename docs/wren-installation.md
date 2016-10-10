# Wren Installation

<!-- newline_to_br : no -->

Linux installs:

* sudo apt-get install gcc
* sudo apt-get install make
* sudo apt-get install libssl-dev
* sudo apt-get install wget
* sudo apt-get install nginx
* sudo apt-get install perl

---

Fast CGI:

* [Nginx and Perl-FastCGI on Ubuntu](https://www.linode.com/docs/websites/nginx/nginx-and-perlfastcgi-on-ubuntu-12-04-lts-precise-pangolin)
 * sudo apt-get install spawn-fcgi
 * sudo apt-get install fcgiwrap

edit `/etc/init.d/fcgiwrap` and add the following lines:

* FCGI_PORT="8999"
* FCGI_ADDR="127.0.0.1"

comment out the following line:

* FCGI_SOCKET="/var/run/$NAME.socket"

set the USER and GROUP appropriately.

---


Perl modules installs:

    $ sudo cpan
    cpan[1]> upgrade

or `sudo perl -MCPAN -e 'upgrade'`

The above will update and test all of the Perl packages. The process may take several minutes to complete.


* sudo perl -MCPAN -e 'install "URI"'
* sudo perl -MCPAN -e 'install "YAML"'
* sudo perl -MCPAN -e 'install HTML::Parser'
* sudo perl -MCPAN -e 'install HTML::Entities'
* sudo perl -MCPAN -e 'install "LWP"'


---


**Wren-required modules to install:**

* sudo perl -MCPAN -e 'install HTML::Template' 
* sudo perl -MCPAN -e 'install Crypt::SSLeay'
* sudo perl -MCPAN -e 'install WWW::Mailgun' 
* JSON::PP - maybe no need to install. from the perldoc: JSON::PP had been included in JSON distribution (CPAN module). It was a perl core module in Perl 5.14.

On my Digital Ocean droplet, I'm using perl 5, version 14, subversion 2 (v5.14.2), 2011. But I'm fairly certain that I needed to install JSON:PP or include the pure perl files for this module in my programs' lib tree.

On my AWS EC2 server, perl 5, version 18, subversion 2 (v5.18.2), 2013. I did not have to install JSON::PP.


---


Obviously, this needs to be made simpler.

Make appropriate DNS changes for the domain name or subdomain name.

Then on the server as user `root`:

* `cd /home`
* `mkdir wren` - (the host directory for the code and website)
* `cd wren`
* `mkdir sessionids`
* `mkdir markup`
* `git clone https://github.com/jrsawvel/Wren.git`
* `mkdir Wren/root/versions`
* `cd Wren/yaml`
* edit yaml config file accordingly
* `cd Wren/lib/Shared`
* edit Config.pm and modify variable that stores the location of the YAML file.
* `cd /home/wren/Wren/root/javascript/splitscreen`
* edit splitscreen.js and change the cookie prefix info if the cookie prefix value was changed in the YAML file. look for the `getCookie` function.
* if necessary, modify images in Wren/root/images
* if the above images were changed, then cd into Wren/tmpl and modify the templates "header.tmpl" and "customarticle.tmpl".
* cd into Wren/nginx
* cp -i wren-nginx.config /etc/nginx/sites-available/[your.domain.name]
* `cd /etc/nginx/sites-available`
* modify the nginx config file for the Wren site accordingly.
* `ln -s /etc/nginx/sites-available/config-file /etc/nginx/sites-enabled/config-file`
* `service nginx restart`
* `cd /home`
* `chown -R user:group wren`
* `cp Wren/json/links.json Wren/root`
* visit http://your.domain.name/wren/login and enter email address stored in YAML file.
* check email for login activation link and click link.
* then visit http://your.domain.name/wren/create and post away


