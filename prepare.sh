#!/bin/bash
mkdir /src
mkdir /dist
mkdir packages

PHP_VERSION=${PHP_VERSION:-7.0}

# Install PHP repository
LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php

apt-get update && apt-get install php${PHP_VERSION}-dev libgpgme11-dev -y

cd /src
echo "[Prepare] Path: ${PWD}"

rm gnupg* -rf
wget https://pecl.php.net/get/gnupg && tar xfvz gnupg
