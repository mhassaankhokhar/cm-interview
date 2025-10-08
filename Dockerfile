FROM node:22-alpine AS builder
WORKDIR /app
COPY app/package.json .
RUN npm install
COPY app/ .
RUN npm run build

FROM nginx:latest
COPY app/default.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/dist/ /usr/share/nginx/html/

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
