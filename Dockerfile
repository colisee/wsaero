FROM php:7.2-apache

LABEL maintainer="colisee@hotmail.com"
LABEL description="wsaero: Aviation Weather"

# Install the php module for xsl
RUN apt-get update && apt-get install -y \
		libxslt1-dev \
	&& docker-php-ext-configure xsl --with-xsl \
	&& docker-php-ext-install -j$(nproc) xsl

# Copy wsaero content
COPY --chown=www-data:www-data App/ /var/www/html/
