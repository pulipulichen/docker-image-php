FROM php:8-apache

RUN apt update

# ---------------------
# MySQL

RUN apt-get install -y nano vim iputils-ping mariadb-client
RUN docker-php-ext-install mysqli pdo pdo_mysql && docker-php-ext-enable pdo_mysql

# ---------------------
# PostgreSQL
# https://github.com/docker-library/php/issues/221#issuecomment-209920424

RUN apt-get install -y libpq-dev \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo pdo_pgsql pgsql
#RUN docker-php-ext-install pdo_pgsql
#RUN docker-php-ext-enable pdo_pgsql 

# ----------------------------------------------------------------
# SQLite
# https://askubuntu.com/a/208398/516010

RUN apt-get install -y sqlite3
#RUN whereis sqlite3
RUN apt-get install -y libsqlite3-dev
RUN docker-php-ext-install pdo_sqlite
RUN docker-php-ext-enable pdo_sqlite 

# -----------------------------------------------------------
# Neo4j
# https://www.lionbloggertech.com/how-to-connect-to-neo4j-with-php/

RUN apt-get install -y git zip unzip
RUN mkdir -p /opt/neo4j
WORKDIR /opt/neo4j/
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"

WORKDIR /var/www/
RUN php /opt/neo4j/composer.phar require laudis/neo4j-php-client
RUN php /opt/neo4j/composer.phar require nyholm/psr7 nyholm/psr7-server kriswallsmith/buzz

ENV PHP_VENDOR=/var/www/

# ---------------------------------------------------------------
# MongoDB
# https://www.mongodb.com/community/forums/t/deploy-docker-container-with-php-mongodb-extension/110168

RUN apt-get install git libssl-dev -y
RUN pecl install mongodb && docker-php-ext-enable mongodb
RUN echo "extension=mongodb.so" >> /usr/local/etc/php/php.ini
COPY --from=composer /usr/bin/composer /usr/bin/composer

# ----------------------------------------------------------------
# SSH

RUN apt-get install -y openssh-server
RUN systemctl enable ssh
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

# ----------------------------------------------------------------
# php memory limit

RUN cd /usr/local/etc/php/conf.d/ && \
  echo 'memory_limit = -1' >> /usr/local/etc/php/conf.d/docker-php-memlimit.ini

# ----------------------------------------------------------------
# php session
# https://stackoverflow.com/a/67727540/6645399

RUN mkdir -p /tmp/session
RUN echo "session.save_path=\"/tmp/session\"" >> /usr/local/etc/php/php.ini



# ---------------------------------------------------------------
# CMD
# 
# Please add the CMD to project.yaml too.

CMD ["apache2-foreground"]