#!/bin/bash
set -e

while ! nc -z mongo 27017;
do
    echo "wait for mongo";
    sleep 3;
done;


# substitute env variables in configuration
envsubst < /opt/learninglocker/.env.template > /opt/learninglocker/.env

# fill up storage directory if it's an empty volume
if [ -z "$(ls -A /opt/learninglocker/storage)" ]; then
    cp -r /opt/learninglocker/storage.template/* /opt/learninglocker/storage/
fi

exec "$@"

