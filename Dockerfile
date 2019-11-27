FROM php:7.3-fpm

RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y --no-install-recommends \
    curl \
    libmemcached-dev \
    libmcrypt-dev \
    libz-dev \
    libpq-dev \
    libjpeg-dev \
    libpng-dev \
    libfreetype6-dev \
    libssl-dev \
    libcurl3-dev \
    libcurl4-openssl-dev \
    libmcrypt-dev \
    libbson-1.0 \
    libmongoc-1.0-0 \
    libxml2-dev \
    libpcre3-dev \
    zlib1g-dev \
    openssh-server \
    openssl \
    pkg-config \
    git \
    vim \
    less \
    htop \
    sendmail \
    wget \
  && rm -rf /var/lib/apt/lists/*

# Install the PHP pdo_mysql extention
RUN docker-php-ext-install pdo_mysql \
  # Install the PHP gd library
  && docker-php-ext-configure gd \
    --with-jpeg-dir=/usr/lib \
    --with-freetype-dir=/usr/include/freetype2 \
  && docker-php-ext-install gd \
  # Install the PHP mbstring library
  && docker-php-ext-install mbstring \
  # Install the PHP soap library
  && docker-php-ext-install soap \
  # Install the PHP xml library
  && docker-php-ext-install xml

# Install the PHP mongodb library
# Only some extensions are available via
# docker-php-ext-install, these must be
# installed via pecl
RUN pecl install mongodb \
    # Install the PHP redis library
    && pecl install redis \
    # Install the XDebug extension
    && pecl install xdebug \
    # Install the mcrypt library
    && pecl install mcrypt \
    # Install the oauth library
    && pecl install oauth \
    # Install the solr library
    && pecl install solr \
    # Install the memcache extension
    && pecl install memcached \
    # Enable PECL extensions
    && docker-php-ext-enable mongodb redis xdebug mcrypt oauth solr memcached

# always run apt update when start and after add new source list, then clean up at end.
RUN set -xe; \
    apt-get update -yqq && \
    pecl channel-update pecl.php.net && \
    apt-get install -yqq \
      apt-utils \
      libzip-dev zip unzip && \
      docker-php-ext-configure zip --with-libzip && \
      docker-php-ext-install zip && \
      php -m | grep -q 'zip'

RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

COPY .docker/php/php.ini "$PHP_INI_DIR/php.ini"
