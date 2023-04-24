# Use the official Nginx image as the base image
FROM nginx:latest

# Copy the Top 10 webpage to the container
COPY index.html /usr/share/nginx/html/

# Expose port 80 to the outside world
EXPOSE 80
