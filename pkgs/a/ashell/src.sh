#!/bin/sh 

for uri in $(cat uris.txt); do
    printf "{ src = { uri = \"$uri\",  sha256sum = \"$(url2sha256sum $uri|cut -d ' ' -f1)\", },\ndest = \"\" },\n"
    
done