# Dokuwiki Apache2 Docker Container

This is a Docker Container with Dokuwiki using the official `php:apache` baseimage. The image is built with the latest Dokuwiki release. It is in an early stage, so please report any occuring errors or bugs. Please be aware I haven't yet looked into serving HTTPS.


To keep your data persistent between container starts you need a plethora of volumes:
* /var/www/html/data/pages/
* /var/www/html/data/meta/
* /var/www/html/data/media/
* /var/www/html/data/media_meta/
* /var/www/html/data/attic/
* /var/www/html/data/media_attic/
* /var/www/html/conf/
* /var/www/html/lib/plugins (if you want plugins)

For now, if you're creating a new Dokuwiki instance without existing content and configuration, the volumes need to be "preloaded" with the default contents. If you have an already existing instance, just use those folders.

Furthermore you must of course expose the HTTP & HTTPS port.

Additionally, as the httpd is not running under root, you need to equalize the UID and/or GID of the `www-data` user with the user whom the dokuwiki files belong to on your host. This can be done by setting two environment variables, `WWW_UID` for the UID and `WWW_GID` for the GID.

Here's an example running the container:

  docker run -e "WWW_UID=1337" -e "WWW_GID=1337" -ti -p 80:80 -p 443:443 -v "/dokuwiki/data/pages/:/var/www/html/data/pages/" -v "/dokuwiki/data/meta/:/var/www/html/data/meta/" -v "/dokuwiki/data/media/:/var/www/html/data/media/" -v "/dokuwiki/data/media_meta/:/var/www/html/data/media_meta/" -v "/dokuwiki/data/attic/:/var/www/html/data/attic/" -v "/dokuwiki/data/media_attic/:/var/www/html/data/media_attic/" -v "/dokuwiki/conf/:/var/www/html/conf/" -v "/dokuwiki/lib/plugins/:/var/www/html/lib/plugins/" m3adow/dokuwiki


Please report any bugs or errors as well as feature requests.
