#!/bin/bash
# Add write permission for files
chmod 777 uploads/
chmod 777 logs/

# To migrate table schema
node ./dist/migrate
