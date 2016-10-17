FROM helder/php-5.3

## Step 2
COPY ./docker-php-pecl-install.sh /usr/local/bin/docker-php-pecl-install

## Step 3
RUN chmod +x /usr/local/bin/docker-php-pecl-install

## Step 4 (install all necessary php extensions)
RUN apt-get update \
 && apt-get install --no-install-recommends -y \
 	libxml2-dev \
 	libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng12-dev \
    libpq-dev \
    libmagickwand-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && mkdir /usr/include/freetype2/freetype \ 
 && ln -s /usr/include/freetype2/freetype.h /usr/include/freetype2/freetype/freetype.h \
 && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
 && docker-php-ext-install gd mbstring pgsql

## Step 5 (upload progress php plugin)
RUN docker-php-pecl-install uploadprogress

## Step 6 (install image magic)
# RUN docker-php-pecl-install imagick-3.1.2 (<-- this doesn't work)
RUN apt-get update && apt-get install -y libmagickwand-6.q16-dev --no-install-recommends \
 && ln -s /usr/lib/x86_64-linux-gnu/ImageMagick-6.8.9/bin-Q16/MagickWand-config /usr/bin \
 && docker-php-pecl-install imagick-3.1.2
