# Dockerfile de Producción Ultra Rápido y Ligero para Flutter Web (Docker Hub oficial)
FROM nginx:alpine

# Copiar la aplicación web compilada de Flutter al directorio público de Nginx
COPY build/web /usr/share/nginx/html

# Exponer el puerto 80 del contenedor
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
