# Use the official PHP image with Apache
FROM php:8.1-apache

# Install necessary dependencies
RUN apt-get update && \
    apt-get install -y \
        libzip-dev \
        zip \
        unzip \
        git \
    && docker-php-ext-install zip pdo_mysql

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Configure Apache server
RUN a2enmod rewrite

# Set the working directory
WORKDIR /var/www/html

# Copy Apache virtual host configuration
COPY .docker/vhost.conf /etc/apache2/sites-available/000-default.conf

# Set environment variable to allow Composer to run as superuser
ENV COMPOSER_ALLOW_SUPERUSER 1

# Install Laravel globally
RUN composer global require laravel/installer

# Copy the .env file (optional)
COPY .env /var/www/html/

# Expose port 80
EXPOSE 80
