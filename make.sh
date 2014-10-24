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
}

function make_apps {
	for app in `find $src -type d -mindepth 1 -maxdepth 1`
	do
		dpkg-deb -b -Zgzip $app 2>/dev/null
	done
	mkdir -p $out/deb
	mv $src/*.deb $_
}

function merge_apps {
	dpkg-scanpackages -m $out >$out/Packages
	gzip -9 -f $out/Packages
}

function clean_vars {
	unset dir
	unset src
	unset out
}

init_vars
reset_out
make_apps
merge_apps
clean_vars
