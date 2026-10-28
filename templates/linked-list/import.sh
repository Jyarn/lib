#!/bin/sh

while [[ $# -gt 0 ]]; do
    case $1 in
        -o|--output)
            OUTPUT_PATH="$2"
            shift
            shift
            ;;
        -s|--struct-prefix)
            STRUCT_PREFIX="$2"
            shift
            shift
            ;;
        -f|--func-prefix)
            FUNC_PREFIX="$2"
            shift
            shift
            ;;
        -t|--elem-type)
            ELEM_TYPE="$2"
            shift
            shift
            ;;
        -n|file-name)
            FILE_NAME="$2"
            shift
            shift
            ;;
        -*|--*)
            echo "Unknown argument $1"
            exit -1
            ;;
    esac
done

if [ -z ${OUTPUT_PATH} ]; then
    echo "Output path undefined."
    exit -1
elif [ -z ${STRUCT_PREFIX} ]; then
    echo "Struct prefix not set."
    exit -1
elif [ -z ${FUNC_PREFIX} ]; then
    echo "Function prefix not set."
    exit -1
elif [ -z ${ELEM_TYPE} ]; then
    echo "Element type not set."
    exit -1
elif [ -z ${FILE_NAME} ]; then
    echo "File name (prefix) not set."
    exit -1
fi

gcc -E linked-list.template.c -DELEM_TYPE=${ELEM_TYPE} -DFUNC_PREFIX=${FUNC_PREFIX} -DSTRUCT_PREFIX=${STRUCT_PREFIX} -DBUILD_ENVIRONMENT -o ./linked-list.temp.c
cat preamble.h ./linked-list.temp.c > ./linked-list.temp2.c
perl -ne 'print unless (/^# \d*/)' ./linked-list.temp2.c > ${OUTPUT_PATH}/${FILE_NAME}.c

gcc -E linked-list.template.h -DELEM_TYPE=${ELEM_TYPE} -DFUNC_PREFIX=${FUNC_PREFIX} -DSTRUCT_PREFIX=${STRUCT_PREFIX} -DBUILD_ENVIRONMENT -o ./linked-list.temp.h
cat preamble.h ./linked-list.temp.h > ./linked-list.temp2.h
echo -e "#pragma once\n" > ${OUTPUT_PATH}/${FILE_NAME}.h
perl -ne 'print unless (/^# \d*/)' ./linked-list.temp2.h >> ${OUTPUT_PATH}/${FILE_NAME}.h

rm ./linked-list.temp.?
rm ./linked-list.temp2.?
