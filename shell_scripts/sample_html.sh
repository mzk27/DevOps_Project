#!/bin/bash

# This script will be run through Jenkins job on a remote server

# Variables
WEB_DIR="/home/ad_zabbix63/DevOps_Project/containers"

# Loop through to create sample index.html for each container
for i in {1..3}; do
    # Create the required directory if it doesn't exist
    sudo mkdir -p "$WEB_DIR/site$i"

    # Create the index.html file
    echo "<html>
    <head>
    <title>Welcome</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            text-align: center;
            background-color: #f0f0f0;
        }
        h1 {
            color: #333;
            margin-top: 50px;
        }
        p {
            color: #666;
            font-size: 1.2em;
        }
    </style>
    </head>
    <body>
    <h1>Welcome to the Test Server</h1>
    <p>This is deployed via Jenkins</p>
    <p>Running in Container $i</p>
    </body>
    </html>
    " | sudo tee "$WEB_DIR/site$i/index.html" > /dev/null

    # Set the correct permissions for the index.html file
    sudo chmod 644 "$WEB_DIR/site$i/index.html"
done

# Print status message
echo "Sample index.html files have been created in the required directories"