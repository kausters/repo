#!/bin/bash

function init_vars {
	dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" # set working directory
	src=$dir/apps
	out=$dir/upload
	deb=$out/deb
}

function purge_out {
	cd $dir
	find . -name '*.DS_Store' -type f -delete
	find . -name '.deb' -type f -delete
	rm -rf $out/*
}

function copy_repo_to_out {
	cd $dir/repo
	cp * $out
}

function make_apps {
	cd $src
	for SRC in `find . -type d -mindepth 1 -maxdepth 1`
	#for SRC in `ls -d */`
	do
		dpkg-deb -b -Zgzip ${SRC} 2>/dev/null
	done
}

function move_apps_to_out {
	mkdir $deb
	mv *.deb $deb
	cd $out
}

function merge_apps {
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
purge_out
copy_repo_to_out
make_apps
move_apps_to_out
merge_apps
clean_vars
