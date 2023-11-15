#!/bin/sh

echo "Exporting hostname..."
export NEXTAUTH_URL_INTERNAL="http://$HOSTNAME:7575"

# Mapping Directories

if [ ! -d /share/homarr/config ]; then
    mkdir -p /share/homarr/config
fi

if [ ! -d /share/homarr/icons ]; then
    mkdir -p /share/homarr/icons
fi

if [ ! -d /share/homarr/data ]; then
    mkdir -p /share/homarr/data
fi

if [ -d /app/data/configs ]; then
    rm -rf /app/data/configs
fi

if [ -d /app/public/icons ]; then
    rm -rf /app/public/icons
fi

if [ -d /data ]; then
    rm -rf /data
fi


ln -s /share/homarr/configs /app/data/configs
ln -s /share/homarr/icons /app/public/icons
ln -s /share/homarr/data /data


echo "Migrating database..."
cd ./migrate; yarn db:migrate & PID=$!
# Wait for migration to finish
wait $PID

## If 'default.json' does not exist in '/app/data/configs', we copy it from '/app/data/default.json'
cp -n /app/data/default.json /app/data/configs/default.json

echo "Starting production server..."
node /app/server.js & PID=$!

wait $PID