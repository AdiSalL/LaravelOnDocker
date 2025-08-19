FROM php:8.3-fpm-alpine

# Install system dependencies yang dibutuhkan Laravel
RUN apk add --no-cache \
    git \
    curl \
    libpng-dev \
    libxml2-dev \
    zip \
    unzip \
    oniguruma-dev \
    libzip-dev \
    freetype-dev \
    libjpeg-turbo-dev \
    libwebp-dev \
    icu-dev

RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install -j$(nproc) \
        pdo_mysql \
        mbstring \
        exif \
        pcntl \
        bcmath \
        gd \
        zip \
        intl \
        opcache

# Install Redis extension untuk caching dan sessions
RUN apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && apk del .build-deps

# Copy Composer dari official image
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy composer files first untuk better layer caching
COPY composer.json composer.lock ./

# Install dependencies PHP menggunakan Composer
RUN composer install --no-dev --optimize-autoloader --no-scripts

# Copy seluruh aplikasi ke dalam container
COPY . .

# Buat direktori yang dibutuhkan Laravel dengan permissions yang benar
RUN mkdir -p /var/www/html/storage/logs \
    && mkdir -p /var/www/html/storage/framework/cache \
    && mkdir -p /var/www/html/storage/framework/sessions \
    && mkdir -p /var/www/html/storage/framework/views \
    && mkdir -p /var/www/html/bootstrap/cache

# Set proper ownership dan permissions - PERBAIKAN UTAMA
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html \
    && chmod -R 775 /var/www/html/storage \
    && chmod -R 775 /var/www/html/bootstrap/cache

# Copy PHP configuration
COPY docker/php/php.ini /usr/local/etc/php/conf.d/99-custom.ini

# Run composer scripts setelah copy
RUN composer dump-autoload --optimize

# Expose port 9000 dan start php-fpm server
EXPOSE 9000

# Switch to www-data user untuk security
USER www-data

# Ganti CMD
CMD ["phpfpm"]
