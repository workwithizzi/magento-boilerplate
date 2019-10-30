FROM php:7.2.6-fpm

# Build ARGs.
ARG IMAGE_VERSION=0.0.1
# ARG MAGENTO_VERSION=2.3.3
ARG MAGERUN_VERSION=3.2.0
ARG IMPORT_SAMPLE_DATA="false"
ARG USER="mag"
ARG HOME_DIR="/mag"
ARG USER_GROUP="magGroup"

ENV MAGENTO_VERSION=2.3.3

#Labels
LABEL maintainer="Yisrael Grimes, yisraelgrimes@gmail.com"
LABEL decription="Magento 2"
LABEL version=$MAGENTO_VERSION
LABEL url="https://github.com/workwithizzi/magento-boilerplate"
LABEL org.label-schema.schema-version=$IMAGE_VERSION

# Create our non-priviledged user that will run magento.
# Group = magGroup
# Username = mag
# Home dir = /mag
# Login Shell = sh
RUN groupadd ${USER_GROUP}
RUN adduser --system --home ${HOME_DIR} --shell /bin/sh  --ingroup ${USER_GROUP} ${USER}


RUN apt-get update && apt-get install -y git libcurl4-gnutls-dev zlib1g-dev libicu-dev g++ libxml2-dev libpq-dev \
	&& git clone https://github.com/phpredis/phpredis.git /usr/src/php/ext/redis \
	&& docker-php-ext-install pdo bcmath pdo_mysql pgsql intl curl json opcache xml redis zip soap\
	&& apt-get autoremove && apt-get autoclean \
	&& rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y libc-client-dev libkrb5-dev && rm -r /var/lib/apt/lists/*
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
	&& docker-php-ext-install imap

# install mongodb ext
RUN pecl install mongodb \
	&& docker-php-ext-enable mongodb

RUN docker-php-ext-install bcmath

RUN apt-get update \
	&& apt-get install -y \
	librabbitmq-dev \
	libssh-dev \
	&& pecl install amqp \
	&& docker-php-ext-enable amqp

RUN apt-get update && apt-get install -y \
	libfreetype6-dev \
	libjpeg62-turbo-dev \
	libmcrypt-dev \
	libpng-dev

RUN apt-get update && \
	apt-get install -y libfreetype6-dev libjpeg62-turbo-dev && \
	docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
	docker-php-ext-install gd

RUN apt-get update && apt-get install -y \
	libfreetype6-dev \
	libjpeg62-turbo-dev \
	libmcrypt-dev \
	libpng-dev

RUN apt-get install -y libxslt-dev

RUN pecl install mcrypt-1.0.2
RUN docker-php-ext-enable mcrypt

# Install all build-deps
RUN apt-get update \
	&& pecl install xdebug \
	&& docker-php-ext-install iconv intl xsl zip pdo_mysql soap \
	&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
	&& docker-php-ext-install gd \
	&& cd /var/tmp \
	&& php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
	&& php composer-setup.php \
	&& php -r "unlink('composer-setup.php');" \
	&& mv composer.phar /usr/local/bin/composer

RUN mkdir -p ${HOME_DIR}/htdocs \
	&& mkdir -p ${HOME_DIR}/logs \
	&& mkdir -p ${HOME_DIR}/cgi-bin \
	&& mkdir -p ${HOME_DIR}/bin \
	&& chown --recursive ${USER}:${USER_GROUP} ${HOME_DIR} \
	# Install Magento
	# && su ${USER} -c "composer -vvv create-project magento/community-edition:${MAGENTO_VERSION} ${HOME_DIR}/htdocs/" \
	# && su ${USER} -c "cd ${HOME_DIR}/htdocs && composer install" \
	# && su ${USER} -c "cd ${HOME_DIR}/htdocs && composer require --no-update n98/magerun2:${MAGERUN_VERSION}" \
	# && su ${USER} -c "cd ${HOME_DIR}/htdocs && composer update" \
	# && su ${USER} -c "cd ${HOME_DIR}/htdocs && composer clear-cache" \
	#
	# I think these are not needed?
	# # && apk del build-deps \
	# && chown --recursive ${USER}:${USER_GROUP} /run/apache2 \
	# && chown --recursive ${USER}:${USER_GROUP} /etc/apache2 \
	&& echo -e "date.timezone=America/Chicago\nmemory_limit=2G\nasp_tags=off\n" > /usr/local/etc/php/php.ini

# Switch to non-priviledged user.
USER ${USER}

# Set our working directory.
WORKDIR ${HOME_DIR}/

# Install sample data if needed.
RUN if [ "${IMPORT_SAMPLE_DATA}" = "true" ]; then \
	cd ${HOME_DIR}/ \
	&& curl -L -O https://github.com${HOME_DIR}/magento2-sample-data/archive/${MAGENTO_VERSION}.tar.gz \
	&& tar xfvz ${MAGENTO_VERSION}.tar.gz \
	&& rm ${MAGENTO_VERSION}.tar.gz \
	&& mv magento2-sample-data-${MAGENTO_VERSION} sample-data \
	&& php -f ${HOME_DIR}/sample-data/dev/tools/build-sample-data.php -- --ce-source=${HOME_DIR}/htdocs/; \
	fi

# Copy assets into the container.
COPY ./docker-assets/ /

# Set all environment variables.
ENV APACHE_HTTPS_PORT_NUMBER="443" \
	APACHE_HTTP_PORT_NUMBER="80" \
	MAGENTO_ADMINURI="admin" \
	MAGENTO_DATABASE_NAME="magento" \
	MAGENTO_DATABASE_PASSWORD="password" \
	MAGENTO_DATABASE_USER="root" \
	MAGENTO_EMAIL="user@example.com" \
	MAGENTO_FIRSTNAME="FirstName" \
	MAGENTO_HOST="127.0.0.1" \
	MAGENTO_LASTNAME="LastName" \
	MAGENTO_MODE="developer" \
	MAGENTO_PASSWORD="password1" \
	MAGENTO_USERNAME="admin" \
	MAGENTO_HOME="${HOME_DIR}/htdocs" \
	MARIADB_HOST="mariadb" \
	MARIADB_PORT_NUMBER="3306" \
	MARIADB_ROOT_PASSWORD="password" \
	MARIADB_ROOT_USER="root" \
	REDIS_HOST="" \
	REDIS_PORT="6379" \
	VARNISH_HOST="" \
	MOD_PAGESPEED_ENABLED="true" \
	IMPORT_SAMPLE_DATA="false" \
	PATH="${HOME_DIR}/htdocs/bin:${HOME_DIR}/htdocs/vendor/bin/:${HOME_DIR}/htdocs/vendor/n98/magerun2/bin:$PATH"

USER root
RUN chown --recursive ${USER}:${USER_GROUP} /etc/apache2
USER ${USER}

# Expose http and https ports.
EXPOSE 80 443

# Setup some helpful commands.
CMD ["/usr/local/bin/entrypoint.sh"]