FROM nginx:alpine
RUN apk update
RUN apk add bash
COPY nginx.conf /etc/nginx/nginx.conf
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80 443
CMD [ "nginx" ]
