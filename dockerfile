FROM therodan/php7-fpm-composer

RUN apt-get update && apt-get install -y nginx supervisor openssl

RUN rm -rf /etc/nginx/conf.d/*; \
    mkdir -p /etc/nginx/ssl

# Nginx
COPY ./conf/basic.conf /etc/nginx/conf.d/basic.conf
COPY ./conf/ssl.conf /etc/nginx/conf.d/ssl.conf
COPY ./conf/default.conf /etc/nginx/sites-available/default.conf
RUN rm /etc/nginx/sites-available/default \
    && ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default.conf

# Supervisor
COPY ./conf/supervisord.conf /etc/supervisord.conf
RUN chmod 400 /etc/supervisord.conf

# Logs
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 80
EXPOSE 443

COPY ./entrypoint.sh /opt/entrypoint.sh
RUN chmod a+x /opt/entrypoint.sh

ENTRYPOINT ["/opt/entrypoint.sh"]

CMD /usr/bin/supervisord -n -c /etc/supervisord.conf