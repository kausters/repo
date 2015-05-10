#!/bin/bash

function init_vars {
	dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" # set working directory
	src=$dir/apps
	out=$dir/upload
}

function reset_out {
	find $src -name '*.DS_Store' -type f -delete
	rm -rf $out
	mkdir -p $out/deb
	cp $dir/repo/* $out
}

function generator {
	for app in `find $src -type d -mindepth 1 -maxdepth 1`; do
		if [ ! -z "`ls $app/versions 2>/dev/null`" ]; then
			appname=`echo "$app" | rev | awk -F / '{print $1}' | rev`
			make_versions $appname
			make_apps $app/tmp
			rm -r $app/tmp
		else
			make_apps $app
		fi
	done
}

function make_versions {
	mkdir -p $app/tmp/var/root/Library/$1
	cp -r $app/DEBIAN $app/tmp
	for version in `find $app/versions -type d -mindepth 1 -maxdepth 1`; do
		dpkg-deb -b -Zgzip $version $app/tmp/var/root/Library/$1 2>/dev/null
	done
}

function make_apps {
	dpkg-deb -b -Zgzip $1 $out/deb 2>/dev/null
}

function composite {
	cd $out
	dpkg-scanpackages -m . >$out/Packages
	gzip -9 -f $out/Packages
}

init_vars
reset_out
generator
composite
