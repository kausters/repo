cd /
for SRC in `find . -type d`
do
	echo ${SRC}
	plutil -convert xml1 ${SRC}/*
done
