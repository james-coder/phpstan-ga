FROM php:7.4-cli

LABEL "com.github.actions.name"="OSKAR-phpstan"
LABEL "com.github.actions.description"="phpstan"
LABEL "com.github.actions.icon"="check"
LABEL "com.github.actions.color"="blue"

LABEL "repository"="http://github.com/oskarstark/phpstan-ga"
LABEL "homepage"="http://github.com/actions"
LABEL "maintainer"="Oskar Stark <oskarstark@googlemail.com>"

COPY --from=composer:1.9.3 /usr/bin/composer /usr/local/bin/composer

RUN mkdir /composer
ENV COMPOSER_HOME=/composer

RUN echo "memory_limit=-1" > $PHP_INI_DIR/conf.d/memory-limit.ini

# https://github.com/mlocati/docker-php-extension-installer
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/
RUN install-php-extensions bcmath intl memcached ssh2 gd zip
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git unzip

# Test running commands ran by composer
RUN mkdir -p /github/workspace/vendor/gitglacier/
RUN git clone --no-checkout 'git@github.com:gitglacier/ardent.git' '/github/workspace/vendor/gitglacier/ardent' && cd '/github/workspace/vendor/gitglacier/ardent' && git remote add composer 'git@github.com:gitglacier/ardent.git' && git fetch composer && git remote set-url origin 'git@github.com:gitglacier/ardent.git' && git remote set-url composer 'git@github.com:gitglacier/ardent.git'
    
RUN composer global require phpstan/phpstan ^0.12.25 \
    && composer global require phpstan/extension-installer \
    && composer global require phpstan/phpstan-doctrine \
    && composer global require phpstan/phpstan-phpunit \
    && composer global require phpstan/phpstan-nette \
    && composer global require phpstan/phpstan-symfony \
    && composer global require phpstan/phpstan-mockery \
    && composer global require phpstan/phpstan-webmozart-assert \
    && composer global show | grep phpstan

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
