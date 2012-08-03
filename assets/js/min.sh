#!/bin/sh

rm production.js
rm production.min.js
cat libs/jquery.symphony.inlineValidation.js common.js > production.js
java -jar ../../../../yuicompressor/build/yuicompressor-2.4.7.jar -v -o production.min.js production.js