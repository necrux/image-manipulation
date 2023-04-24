#!/usr/bin/env bash

function usage {
cat << EOF
This is a skeletion usage function. It contains a short description, command syntax,
and a list of available options.

SYNTAX
  $0 [ -i | -p | -s | -c | -h ]

  -i               Specify the image.
  -p               Print image details only.
  -s               Specify the image dimensions.
  -c               Convert image.
  -h               Print this message and exit.
EOF
}

function is-command {
    # Check if command(s) is installed.
    local FAILURE

    for program in $@; do
        hash ${program} > /dev/null 2>&1
        if [ $? != 0 ]; then
            echo "Command not found: ${program}" >&2
            FAILURE='true'
        fi
    done

    if [ ! -z ${FAILURE} ]; then
        exit 127
    fi
}

function is-file {
    if [ ! -f ${IMAGE} ]; then
        err 69 "Cannot locate image: ${IMAGE}"
    fi
}

function print-details {
    local WIDTH=$(identify -format "%w" ${IMAGE})
    local HEIGHT=$(identify -format "%h" ${IMAGE})

    if [ ${WIDTH} -eq ${HEIGHT} ]; then
        FORMAT="square"
    elif [ ${HEIGHT} -gt ${WIDTH} ]; then
	FORMAT="portrait"
    else
	FORMAT="landscape"
    fi
    echo -e "Image details: ${IMAGE}\n"
    identify -ping ${IMAGE}
    echo -e "This image is: ${FORMAT}\n" 
    exit 0
}

function err {
    # Send message to stderr with a timestamp; $1 is the returned exit status.
    local EXIT=$1
    shift 1
    echo "[$(date +'%Y-%m-%d %H:%M:%S')]: $@" >&2
    exit ${EXIT}
}

is-command convert identify

while getopts "i:ps:ch" arg; do
  case $arg in
    i)
	IMAGE=${OPTARG}
	is-file
        ;;
    p)
	print-details
        ;;
    s)
	echo 'placeholder'
        ;;
    c)
	echo 'placeholder'
        ;;
    h)
        usage 
	exit
        ;;
  esac
done
