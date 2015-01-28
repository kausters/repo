#!/bin/bash

function init_vars {
	dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" # set working directory
	src=$dir/apps
	out=$dir/upload
}

function reset_out {
	find $src -name '*.DS_Store' -type f -delete
	rm -rf $out/*
	cp $dir/repo/* $out
	mkdir -p $out/deb
}

function generator {
	for app in `find $src -type d -mindepth 1 -maxdepth 1`; do
		if [ ! -z "`ls $app/versions 2>/dev/null`" ]; then
			make_versions
			make_apps $app/tmp
			rm -r $app/tmp
		else
			make_apps $app
		fi
	done
}

function make_versions {
	mkdir -p $app/tmp
	cp -r $app/DEBIAN $app/tmp
	for version in `find $app/versions -type d -mindepth 1 -maxdepth 1`; do
		dpkg-deb -b -Zgzip $version $app/tmp 2>/dev/null
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
