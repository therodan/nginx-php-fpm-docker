FROM therodan/php7-fpm-composer

RUN apt-get update && apt-get install -y nginx supervisor

# Supervisor
COPY ./conf/supervisord.conf /etc/supervisord.conf

# Nginx
COPY ./conf/default.conf /etc/nginx/conf.d/default.conf

# Logs
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 80

CMD /usr/bin/supervisord -n -c /etc/supervisord.conf