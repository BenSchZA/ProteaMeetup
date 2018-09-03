# Use LTS Node environment as build environment
FROM node:carbon AS builder

ARG NETWORK
ENV NETWORK ${NETWORK}

# Initialize working directory
RUN mkdir -p /build
WORKDIR /build
ADD . /build

# Install necessary dependancies
RUN npm install -g truffle
RUN yarn install

# Configure deployment environment
#ENV NODE_ENV=development
#ENV NODE_ENV=production

# Build application
RUN truffle compile
RUN yarn run build

CMD truffle migrate --network ${NETWORK}

# Use Nginx server to serve 'dist' directory
FROM nginx:alpine

COPY nginx.conf /etc/nginx/nginx.conf

WORKDIR /usr/share/nginx/html
COPY --from=builder /build/dist/ProteaMeetup/ .

EXPOSE 80
