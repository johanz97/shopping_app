#!/bin/bash

# Welcome
echo 'Server start script initialized...'

# Set the port
PORT=4040

# Change directories to the release folder
cd build/web/

# Start the server
echo 'Starting Supercash Flutter Web server on port' $PORT '...'
python3 -m http.server $PORT

# Exit
echo 'Supercash Flutter Web Server exited...'
