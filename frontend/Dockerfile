# Stage 1: Build Flutter Web App
FROM ghcr.io/cirrusci/flutter:stable AS build-stage

WORKDIR /app

# Copy dependency definition
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

# Copy source code and build web release
COPY . .
RUN flutter build web --release

# Stage 2: Serve using Nginx Light Web Server
FROM nginx:alpine AS production-stage

# Copy web build artifact from build-stage to Nginx default public directory
COPY --from=build-stage /app/build/web /usr/share/nginx/html

# Expose port 80
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
