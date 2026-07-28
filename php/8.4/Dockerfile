FROM php:8.4-apache

ARG UID=1000
ARG GID=1000

# ---------------------------------------------------------------------------
# PHP extensions
#
# Already compiled into php:8.2-apache (no action needed):
#   mbstring, curl, xml/dom/simplexml, json, openssl, fileinfo, pdo, pdo_sqlite
#
# Bundled with PHP source but NOT enabled -> must be built here:
#   zip  (needs libzip-dev)
#   gd   (needs libpng / libjpeg / libfreetype / libwebp dev headers)
#   exif (no external dependencies)
#   mysqli, pdo_mysql (no external dependencies, mysqlnd is built in)
# ---------------------------------------------------------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
        libzip-dev \
        libpng-dev \
        libjpeg62-turbo-dev \
        libfreetype6-dev \
        libwebp-dev \
        unzip \
    && docker-php-ext-configure gd \
        --with-freetype \
        --with-jpeg \
        --with-webp \
    && docker-php-ext-install -j"$(nproc)" \
        mysqli \
        pdo_mysql \
        zip \
        gd \
        exif \
    && rm -rf /var/lib/apt/lists/*

# Enable Apache modules
RUN a2enmod rewrite

# Copy PHP config
COPY ./php.ini /usr/local/etc/php/

# Optional: Add custom virtual hosts support (if needed)
# COPY ../../apache/vhosts/*.conf /etc/apache2/sites-enabled/

# RUN touch /var/log/php_errors.log && chmod 640 /var/log/php_errors.log

WORKDIR /var/www/html

# Match container user to host user (group first, then user)
RUN groupmod -g ${GID} www-data \
    && usermod -u ${UID} -g ${GID} www-data

# RUN chown -R www-data:www-data /var/www/html
# RUN chmod -R 775 /var/www/html

