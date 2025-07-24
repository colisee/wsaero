FROM php:7-apache

LABEL maintainer="colisee@hotmail.com" \
      description="wsaero: Aviation Weather"

# Copy wsaero content
COPY --chown=www-data:www-data App /var/www/html/

# Install the php module for xsl
RUN apt-get update; \
    apt-get install --yes libxslt1-dev; \
    docker-php-ext-configure xsl --with-xsl; \
    docker-php-ext-install -j$(nproc) xsl
