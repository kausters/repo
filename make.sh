#!/bin/bash

function init {
	dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" # set working directory
	src=$dir/apps
	out=$dir/upload
	deb=$out/deb
}

function purge {
	cd $dir
	find . -name '*.DS_Store' -type f -delete
	find . -name '.deb' -type f -delete
	rm -rf $out/*
}

function copy_repo {
	cd $dir/repo
	cp * $out
}

function compile {
	cd $src
	for SRC in `find . -type d -mindepth 1 -maxdepth 1`
	#for SRC in `ls -d */`
	do
		dpkg-deb -b -Zgzip ${SRC} 2>/dev/null
	done
}

function move {
	mkdir $deb
	mv *.deb $deb
	cd $out
}

function merge {
	dpkg-scanpackages -m . >Packages
	gzip -9 -f Packages
}

function clean {
	unset dir
	unset src
	unset out
	unset deb
}

init
purge
copy_repo
compile
move
merge
clean
