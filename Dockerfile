# Check out https://hub.docker.com/_/node to select a new base image
FROM node:21-slim

# Install Lb4
RUN npm install @loopback/cli -g

# Set to a non-root built-in user `node`
USER node

# Create app directory (with user `node`)
RUN mkdir -p /home/node/app

WORKDIR /home/node/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY --chown=node build/ ./
COPY --chown=node package*.json ./
#COPY --chown=node pm2.config.js ./

# Bind to all network interfaces so that it can be mapped to the host OS
ENV HOST=0.0.0.0 PORT=3000

# Install dependencies
RUN npm install

# Expose application port
EXPOSE ${PORT}
