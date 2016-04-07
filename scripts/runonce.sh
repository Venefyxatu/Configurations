#!/bin/bash

ps aux |grep "$1" |grep -v grep |grep -v runonce.sh > /dev/null 2>&1

if [ $? -ne 0 ]
then
    echo "Running $@"
    $@
else
    echo "$1 is already running"
fi
