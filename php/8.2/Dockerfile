FROM php:8.2-apache

ARG UID=1000
ARG GID=1000

# Install needed PHP extensions
RUN docker-php-ext-install mysqli pdo pdo_mysql

# RUN apt-get update && apt-get install -y \
#     libpng-dev \
#     libjpeg-dev \
#     libonig-dev \
#     libxml2-dev \
#     zip \
#     unzip \
#     curl \
#     && docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd

# Enable Apache modules
RUN a2enmod rewrite

# Copy PHP config
COPY ./php.ini /usr/local/etc/php/

# Optional: Add custom virtual hosts support (if needed)
# COPY ../../apache/vhosts/*.conf /etc/apache2/sites-enabled/

# RUN touch /var/log/php_errors.log && chmod 640 /var/log/php_errors.log

WORKDIR /var/www/html

RUN usermod -u ${UID} www-data
RUN groupmod -g ${GID} www-data

# RUN usermod -u <your-host-uid> www-data
# RUN groupmod -g <your-host-gid> www-data

# RUN chown -R www-data:www-data /var/www/html
# RUN chmod -R 775 /var/www/html
