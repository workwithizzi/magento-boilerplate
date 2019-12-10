FROM php:7.2.6-cli
RUN apt-get update && apt-get install -y git libcurl4-gnutls-dev zlib1g-dev libicu-dev g++ libxml2-dev libpq-dev \
 && git clone https://github.com/phpredis/phpredis.git /usr/src/php/ext/redis \
 && docker-php-ext-install pdo pdo_mysql pgsql intl curl json opcache xml redis zip soap \
 && apt-get autoremove && apt-get autoclean \
 && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y libc-client-dev libkrb5-dev && rm -r /var/lib/apt/lists/*
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install imap


# Install cron
RUN set -ex; \
   \
   apt-get update; \
   apt-get install -y \
      cron \
      mysql-client \
      curl \
   ; \
   rm -rf /var/lib/apt/lists/*

# Add crontab file in the cron directory
ADD crontab /etc/crontab

# Give execution rights on the cron job
RUN chmod 0644 /etc/crontab
RUN mkdir /var/log/notos

RUN crontab /etc/crontab

# Create the log file to be able to run tail
RUN touch /var/log/cron.log

# Run the command on container startup
CMD cron && tail -f /var/log/cron.log


