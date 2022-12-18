FROM nginx:latest

COPY server.js /usr/share/nginx/js

EXPOSE 8080 443 	

CMD ["nginx", "-g", "daemon off;"]
