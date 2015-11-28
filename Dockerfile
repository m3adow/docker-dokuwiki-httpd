FROM php:apache
MAINTAINER m3adow

RUN curl http://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz | tar xzvf - --strip 1 \
	&& apt-get update && apt-get install --auto-remove -y sudo \
	&& apt-get clean \
	&& rm -r /var/lib/apt/lists/* \
	&& chown -R www-data:www-data /var/www/html/??*
ADD ["./change_uid_www.sh", "/usr/local/bin/"]

VOLUME ["/var/www/html/data/pages/", "/var/www/html/data/meta/", "/var/www/html/data/media/", \
	"/var/www/html/data/media_meta/", "/var/www/html/data/attic/", \
	"/var/www/html/data/media_attic/", "/var/www/html/conf/"]

EXPOSE 80 443
ENTRYPOINT ["/usr/local/bin/change_uid_www.sh"]
CMD ["/usr/local/bin/apache2-foreground"]