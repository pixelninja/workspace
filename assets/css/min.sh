#!/bin/sh

rm production.css
rm production.min.css
cat reset.css default.css > production.css
java -jar ../../../../yuicompressor/build/yuicompressor-2.4.7.jar -v -o production.min.css production.css
