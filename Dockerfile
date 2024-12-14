# Use Apache HTTP server as the base image
FROM httpd:2.4

# Copy website files to Apache's default directory
COPY ./ /usr/local/apache2/htdocs/