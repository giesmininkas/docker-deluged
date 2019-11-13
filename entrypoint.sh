#!/bin/bash

CONFIG_DIR=/var/lib/deluged/config

if [ -d "$CONFIG_DIR" ] && [ ! "$(ls -A $CONFIG_DIR)" ]; then
	if [ ! -z "$AUTH_USERNAME" ] && [ ! -z "$AUTH_PASSWORD" ]; then
		echo "$AUTH_USERNAME:$AUTH_PASSWORD:10" > /configs/auth
	fi

	cp -r /configs/* $CONFIG_DIR
fi

/usr/bin/deluged -d -c $CONFIG_DIR -l /var/log/deluged/daemon.log -L info
