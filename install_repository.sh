#!/bin/bash

SHELLPATH=$(cd "$(dirname "$0")"; pwd)

TARGET_DIR=$2
if [ ${TARGET_DIR:0:1} != "/" ]; then
	TARGET_DIR=`pwd`/${TARGET_DIR}
fi

#############################################
# util
trim_space()
{
	echo $1 | sed 's/^\s*\|\s*$//g'
}
trim_crlf()
{
	echo $1 | sed 's/\r//g'
}
#############################################

unzip_package()
{
	local SRC_FILE="$1"
	local DST_DIR="$2"
	
	if [ -d "${DST_DIR}" ]; then
		return
	fi
	
	local TEMP_DIR="temp_install"
	rm -rf "${TEMP_DIR}"
	mkdir "${TEMP_DIR}"
	cd "${TEMP_DIR}"
	unzip ${SRC_FILE}
	cd -
	local UNZIP_DIR=`ls -1 "${TEMP_DIR}"`
	if [ `echo "$UNZIP_DIR" | wc -l` != "1" ]; then
		echo "unexpected error,$UNZIP_DIR"
		rm -rf "${TEMP_DIR}"
		return
	fi
	
	PARENT_DIR=`dirname "$DST_DIR"`
	mkdir -p "${PARENT_DIR}"
	mv "${TEMP_DIR}/$UNZIP_DIR" "$DST_DIR"
	rm -rf "${TEMP_DIR}"
}

cat $1 | while read line
do
	line=`trim_crlf "$line"`
	if [ "$line" = "" ]; then
		continue
	fi
	if [ "${line:0:1}" = "#" ]; then
		# comment
		continue
	fi
	
	SRC_FILE=${SHELLPATH}/repository/${line%%,*}
	#DST_DIR is the second
	DST_DIR=${line#*,}
	DST_DIR=${DST_DIR%%,*}
	DST_DIR=${TARGET_DIR}/`trim_space "${DST_DIR}"`
	unzip_package "$SRC_FILE" "$DST_DIR" 
done