#!/bin/bash

# Jenkins environment variables
APP_NAME="${APP_NAME}"
VERSION_NAME="${VERSION_NAME}"
BUILD_NUMBER="${BUILD_NUMBER}"

# Manually obtain the current date and time
current_date_time="$(date +'%d-%b-%Y %I:%M:%S %p')"

# Build directory
buildFolder="build"

# Check for dir, if  found delete it using the rm command ##
[ -d "$buildFolder" ] && rm -r $buildFolder

# Install dependencies
npm install -g @loopback/cli
npm install

# To make the build of the application
npm run rebuild

# Create build folder
mkdir "$buildFolder"

# Copy package.json file to the build directory
cp package*.json "$buildFolder/"

# Copy firebase.*.json file to the build directory
#cp firebase*.json "$buildFolder/"

# Copy dist directory to the build directory
cp -r dist/ "$buildFolder/"

# Copy public directory to the build directory
cp -rf public/ "$buildFolder/public"

# Remove index.html inside public directory
rm -rf "$buildFolder/public/index.html"

# Create index.html inside public directory
echo '<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>'"$APP_NAME"'</title>
</head>
<body>
    <div><strong>App Name:</strong> '"$APP_NAME"'</div>
    <div><strong>Version:</strong> '"$VERSION_NAME"."$BUILD_NUMBER"'</div>
    <div><strong>Time:</strong> '"$current_date_time"'</div>
</body>
</html>' > "$buildFolder/public/index.html"

# Remove test folder
rm -rf "$buildFolder/__tests__"

# Make the logs directory for the logger service
mkdir -p "$buildFolder/logs/"

# Make the logs directory fot the eprom and fota service
mkdir -p "$buildFolder/uploads/eprom"
mkdir -p "$buildFolder/uploads/fota"

# To make a copy of migrate script to build directory
#cp migrate.sh "$buildFolder/"
