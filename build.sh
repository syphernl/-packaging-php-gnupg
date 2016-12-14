#!/bin/bash
source vars.sh

PHP_VERSION=${PHP_VERSION:-7.0}

echo "Building package..."

OLDPATH=${PWD}
echo "[Build] Current path: ${PWD}"
cd /src/gnupg*/

APP_VERSION=$(grep PHP_GNUPG_VERSION php_gnupg.h | awk {'print $3'} | sed -e 's/^"//' -e 's/"$//')
ITERATION_FILE="${OLDPATH}/iteration_${APP_VERSION}"
APP_ITERATION=`cat ${ITERATION_FILE}`
APP_ITERATION=$((APP_ITERATION+1))
echo ${APP_ITERATION} > "${ITERATION_FILE}"

echo "Building PHP-GNUPG ${APP_VERSION}..."
phpize 2>&1 | tee log_phpize && ./configure && make && make install
PHP_API_VERSION=$(grep "PHP Api Version" log_phpize | awk {'print $4'})

echo "[Build] Current path: ${PWD}"
# Copy module file
mkdir -p /dist/package/usr/lib/php/${PHP_API_VERSION}/
cp /usr/lib/php/${PHP_API_VERSION}/gnupg.so /dist/package/usr/lib/php/${PHP_API_VERSION}/

# Enable the module
mkdir -p /dist/package/etc/php/${PHP_VERSION}/mods-available
echo "extension=gnupg.so" >> /dist/package/etc/php/${PHP_VERSION}/mods-available/gnupg.ini

echo "[Build] Current path: ${PWD}"

cd "/dist/package/"

echo "[Build] Current path: ${PWD}"

fpm --verbose -s dir -t deb \
--url "https://pecl.php.net/package/gnupg" \
--description "Wrapper around the gpgme library" \
--license "BSD License" \
--maintainer "$PKG_MAINTAINER" \
--vendor "$PKG_VENDOR" \
--version "${APP_VERSION:-1.0}" \
--iteration "${APP_ITERATION}" \
--depends "php${PHP_VERSION}-common" \
--after-install /build/scripts/post-install.sh \
--before-remove /build/scripts/pre-remove.sh \
-n php-gnupg .

mv *.deb /build/packages
