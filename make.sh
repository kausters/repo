#!/bin/bash

function init {
	dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" # set working directory
}

function clean {
	cd $dir
	find . -name '*.DS_Store' -type f -delete
	find . -name '.deb' -type f -delete
	rm -f $dir/upload/Packages.gz
	rm -rf $dir/upload/deb/
}

function compile {
	cd $dir/apps
	for SRC in `find . -type d -mindepth 1 -maxdepth 1`
	#for SRC in `ls -d */`
	do
		dpkg-deb -b -Zgzip ${SRC}
	done
}

function move {
	mkdir $dir/upload/deb/
	mv *.deb $dir/upload/deb/
	cd $dir/upload
}

function merge {
	dpkg-scanpackages -m . /dev/null >Packages
	gzip -9 -f Packages
}

init
clean
compile
move
merge
