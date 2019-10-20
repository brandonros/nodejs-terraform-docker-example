FROM node:alpine
# Create app directory
WORKDIR /app
# Install app dependencies
COPY package.json ./
COPY yarn.lock ./
RUN yarn install --production
# Bundle app source
COPY . .
# Export command
CMD [ "node", "index.js" ]
