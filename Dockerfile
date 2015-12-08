FROM php:apache
MAINTAINER m3adow

RUN curl http://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz | tar xzvf - --strip 1 \
	&& apt-get update && apt-get install --auto-remove -y sudo \
	&& apt-get clean \
	&& rm -r /var/lib/apt/lists/* \
	&& chown -R www-data:www-data /var/www/html/??*
COPY ["./wannabe-user.sh/wannabe-user.sh", "/usr/local/bin/"]
VOLUME ["/var/www/html/data/pages/", "/var/www/html/data/meta/", "/var/www/html/data/media/", \
	"/var/www/html/data/media_meta/", "/var/www/html/data/attic/", \
	"/var/www/html/data/media_attic/", "/var/www/html/conf/", "/var/www/html/lib/plugins"]

EXPOSE 80 443
ENTRYPOINT ["/usr/local/bin/wannabe-user.sh", "-u", "33", "-g", "33", "-f", "/var/www/html/conf"]
CMD ["/usr/local/bin/apache2-foreground"]
