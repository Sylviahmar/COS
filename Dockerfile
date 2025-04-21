# Build stage
FROM node:20 as build

WORKDIR /app

# Copy package files and install dependencies
COPY package.json package-lock.json* ./
RUN npm ci

# Copy source code and build
COPY . .
RUN npm run build

# Production stage
FROM nginx:alpine

# Copy build output from build stage
COPY --from=build /app/build /usr/share/nginx/html

# Instead of copying a non-existent file, create a basic nginx config
RUN echo 'server { \
    listen       80; \
    server_name  localhost; \
    location / { \
    root   /usr/share/nginx/html; \
    index  index.html index.htm; \
    try_files $uri $uri/ /index.html; \
    } \
    error_page   500 502 503 504  /50x.html; \
    location = /50x.html { \
    root   /usr/share/nginx/html; \
    } \
    }' > /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]