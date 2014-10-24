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

function make_apps {
	for app in `find $src -type d -mindepth 1 -maxdepth 1`
	do
		dpkg-deb -b -Zgzip $app $out/deb 2>/dev/null
	done
}

function composite {
	cd $out
	dpkg-scanpackages -m . >$out/Packages
	gzip -9 -f $out/Packages
}

init_vars
reset_out
make_apps
composite
