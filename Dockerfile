FROM node:22-alpine AS builder
WORKDIR /app
COPY app/package.json .
RUN npm install
COPY app/ .
RUN npm run build
# Stage 2
FROM nginx:stable
RUN rm /etc/nginx/nginx.conf /etc/nginx/conf.d/default.conf

RUN apt-get update && apt-get upgrade -y \
    && apt install nano curl -y \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/cache/nginx/client_temp && \
        mkdir -p /var/cache/nginx/proxy_temp && \
        mkdir -p /var/cache/nginx/fastcgi_temp && \
        mkdir -p /var/cache/nginx/uwsgi_temp && \
        mkdir -p /var/cache/nginx/scgi_temp && \
        chown -R nginx:nginx /var/cache/nginx && \
        chown -R nginx:nginx /etc/nginx/ && \
        chown -R nginx:nginx /usr/share/nginx/ && \
        chmod -R 755 /etc/nginx/ && \
        chmod -R 755 /usr/share/nginx && \
        chown -R nginx:nginx /var/log/nginx

RUN mkdir -p /etc/nginx/ssl/ && \
    chown -R nginx:nginx /etc/nginx/ssl/ && \
    chmod -R 755 /etc/nginx/ssl/

RUN touch /var/run/nginx.pid && \
        chown -R nginx:nginx /var/run/nginx.pid /run/nginx.pid

USER nginx

COPY app/nginx.conf /etc/nginx/nginx.conf
COPY --from=builder /app/dist/ /usr/share/nginx/html/
EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
