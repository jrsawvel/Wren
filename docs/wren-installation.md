# Wren Installation

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


