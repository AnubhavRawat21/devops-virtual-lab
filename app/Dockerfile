# Production Grade Nginx Alpine Image
FROM nginx:alpine

# Copy custom web application contents
COPY index.html /usr/share/nginx/html/index.html

# Expose HTTP port
EXPOSE 80

# Start Nginx server in the foreground
CMD ["nginx", "-g", "daemon off;"]
