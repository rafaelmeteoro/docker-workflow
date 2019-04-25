# same as Dockerfile.dev except adding AS builder to the FROM argument
FROM node:11.10.1-alpine AS builder
WORKDIR '/app'
COPY package.json .
RUN npm install
COPY . .
# except this command, should be npm run build
RUN npm run build

# I used nginx image from alpine to copy over the result of 'npm run build'
# then start the nginx server
FROM nginx
# nginx consumes port 80 - from dockerhub documentation
EXPOSE 80
# I want to copy over the builder phase - which folder I want to copy - where the copy should go
COPY --from=builder /app/build /usr/share/nginx/html
