#!/bin/bash
mkdir /src
mkdir /dist
mkdir packages

apt-get update && apt-get install libgpgme11-dev -y

cd /src
echo "[Prepare] Path: ${PWD}"

rm gnupg* -rf
wget https://pecl.php.net/get/gnupg && tar xfvz gnupg
