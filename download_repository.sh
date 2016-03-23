#!/bin/bash

if [ "$1" = "" ]; then
	echo "download_repository.sh conf/API22.txt"
	exit
fi

SHELLPATH=$(cd "$(dirname "$0")"; pwd)

MIRROR_SITE="http://mirrors.neusoft.edu.cn/android/repository"

download_package()
{
	local SRC_FILE=${MIRROR_SITE}/$1
	local DST_FILE=${SHELLPATH}/repository/$1
	local DST_DIR=`dirname ${DST_FILE}`
	
	if [ ! -f ${DST_FILE} ]; then
		mkdir -p ${DST_DIR}
		echo "download ${SRC_FILE}"
		wget ${SRC_FILE} -O ${DST_FILE}
	fi
}

cat $1 | while read line
do
	if [ "$line" = "" ]; then
		continue
	fi
	if [ "${line:0:1}" = "#" ]; then
		# comment
		continue
	fi
	
	DST_FILE=${line%%,*}
	download_package $DST_FILE
done