# Base image as node:21-slim
FROM node:21-slim

# Set npm warning level
ENV NPM_CONFIG_LOGLEVEL error

# Install pm2
#RUN npm install pm2 -g

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

# Show current folder structure in logs
#RUN ls -al -R

CMD [ "pm2-runtime", "start", "pm2.config.js" ]
