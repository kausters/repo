#!/bin/bash

function init_vars {
	dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" # set working directory
	src=$dir/apps
	out=$dir/upload
	deb=$out/deb
}

function reset_out {
	find $src -name '*.DS_Store' -type f -delete
	rm -rf $out/*
	cp $dir/repo/* $out
	mkdir $deb
}

function make_apps {
	cd $src
	for SRC in `find . -type d -mindepth 1 -maxdepth 1`
	#for SRC in `ls -d */`
	do
		dpkg-deb -b -Zgzip ${SRC} 2>/dev/null
	done
	mv $src/*.deb $deb
}

function merge_apps {
	cd $out
	dpkg-scanpackages -m . >Packages
	gzip -9 -f Packages
}

function clean_vars {
	unset dir
	unset src
	unset out
	unset deb
}

init_vars
reset_out
make_apps
merge_apps
clean_vars
