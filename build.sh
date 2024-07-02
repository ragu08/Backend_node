#!/bin/bash

# Jenkins environment variables (ensure they are set appropriately)
APP_NAME="${APP_NAME}"
VERSION_NAME="${VERSION_NAME}"
BUILD_NUMBER="${BUILD_NUMBER}"

# Check if required variables are set
if [ -z "$APP_NAME" ] || [ -z "$VERSION_NAME" ] || [ -z "$BUILD_NUMBER" ]; then
    echo "Error: Required Jenkins environment variables are not set."
    exit 1
fi

# Manually obtain the current date and time
current_date_time="$(date +'%d-%b-%Y %I:%M:%S %p')"

# Build directory
buildFolder="build"

# Check if build directory exists, delete it if it does
if [ -d "$buildFolder" ]; then
    rm -r "$buildFolder"
fi

# Create build folder
mkdir "$buildFolder"


# Install dependencies
npm install -g @loopback/cli
npm install

# Create build folder
mkdir "$buildFolder"

# To make the build of the application
npm run rebuild

# Copy package.json file to the build directory
cp package*.json "$buildFolder/"

# Copy firebase.*.json file to the build directory
cp firebase*.json "$buildFolder/"

# Copy dist directory to the build directory
cp -r dist/ "$buildFolder/"

# Copy pulbic directory to the build directory
cp -rf public/ "$buildFolder/public"

# Remove test folder
rm -rf "$buildFolder/__tests__"

# Make the logs directory fot the logger service
mkdir "$buildFolder/logs/"

# Create public directory if it doesn't exist
publicFolder="$buildFolder/public"
mkdir -p "$publicFolder"

# Create index.html inside public directory
indexFile="$publicFolder/index.html"
echo '<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>'"$APP_NAME"'</title>
</head>
<body>
    <div><strong>App Name:</strong> '"$APP_NAME"'</div>
    <div><strong>Version:</strong> '"$VERSION_NAME.$BUILD_NUMBER"'</div>
    <div><strong>Time:</strong> '"$current_date_time"'</div>
</body>
</html>' > "$indexFile"

# Make the logs directory fot the eprom and fota service
mkdir -p "$buildFolder/uploads/eprom"
mkdir -p "$buildFolder/uploads/fota"

# To make a copy of migrate script to build directory
cp migrate.sh "$buildFolder/"
