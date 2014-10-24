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
	rm -f $out/Packages.gz
	rm -rf $deb
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
	dpkg-scanpackages -m . /dev/null >Packages 2>/dev/null
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
compile
move
merge
clean
