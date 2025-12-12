#!/bin/sh -e

if [ "$1" = "list-locales" ]; then
	for f in $(ls /usr/share/locale); do
		printf "${f}.UTF-8\n"
	done
else
	exit 1
fi
