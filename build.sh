#!/bin/bash

function init_vars {
	dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" # set working directory
	src=$dir/apps
	out=$dir/upload
}

function reset_out {
	rm -rf "$out"
	find "$src" -name '*.DS_Store' -type f -delete
	mkdir -p "$out/deb"
	cp "$dir/repo"/* "$out"
}

function generator {
	declare -a packages
	while IFS= read -r -d '' n; do
	  packages+=( "$n" )
	done < <(find "$src" -type d -mindepth 1 -maxdepth 1 -print0)

	for app in "${packages[@]}"; do
		versions=`ls \"$app/versions\" 2>/dev/null`
		if [ ! -z $versions ]; then
			appname=`echo "$app" | rev | awk -F / '{print $1}' | rev`
			make_versions "$appname"
			make_apps "$app/tmp"
			rm -r "$app/tmp"
		else
			make_apps "$app"
		fi
	done
}

function make_versions {
	mkdir -p "$app/tmp/var/root/Library/$1"
	cp -r "$app/DEBIAN" "$app/tmp"

	declare -a versions
	while IFS= read -r -d '' n; do
	  versions+=( "$n" )
	done < <(find "$app/versions" -type d -mindepth 1 -maxdepth 1 -print0)

	for version in "${versions[@]}"; do
		dpkg-deb -b -Zgzip "$version" "$app/tmp/var/root/Library/$1" 2>/dev/null
	done
}

function make_apps {
	dpkg-deb -b -Zgzip "$1" "$out/deb" 2>/dev/null
}

function composite {
	cd "$out"
	dpkg-scanpackages -m . >"$out/Packages"
	gzip -9 -f "$out/Packages"
}

init_vars
reset_out
generator
composite
