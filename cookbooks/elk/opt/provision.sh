#!/bin/sh -e

[ -z $HOST ] && HOST=$1
[ -z $HOST_USER ] && HOST_USER=$2
[ -z $RUN_LIST ] && RUN_LIST="elk::default"
[ -z $ATTRIBUTES_FILE ] && ATTRIBUTES_FILE=$3


info() {
    echo -e "\033[1;37m$@\033[0m"
}

error() {
    echo -e "\033[1;31m$@\033[0m"
}

usage() {
    info "Usage: ./provision HOST HOST_USER ATTRIBUTES_FILE"
}

cleanup() {
    info "Cleaning up berks-cookbooks ..."
    if [ -e berks-cookbooks ]; then
        rm -rf berks-cookbooks
    fi
}

create_berks_cookbooks() {
    info "Creating bersks-cookbooks ..."
    berks vendor berks-cookbooks --berksfile=../Berksfile
}

cleanup
create_berks_cookbooks

if [ -z $ATTRIBUTES_FILE ]; then
    error "ATTRIBUTES_FILE environment variable not provided !"
    usage
    exit 1
fi

knife zero bootstrap $HOST \
      -c ./knife.rb \
      -x $HOST_USER \
      -r $RUN_LIST \
      -N $HOST \
      --json-attribute-file $ATTRIBUTES_FILE \
      --sudo

cleanup
