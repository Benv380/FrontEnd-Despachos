FROM node:20-alpine AS builder

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci --silent

ARG VITE_API_URL=http://localhost:8081
ENV VITE_API_URL=$VITE_API_URL

COPY . .
RUN npm run build

FROM nginx:1.27-alpine

RUN chown -R nginx:nginx /var/cache/nginx /var/run /var/log/nginx /etc/nginx/conf.d && \
    chmod -R 755 /var/cache/nginx && \
    touch /run/nginx.pid && \
    chown nginx:nginx /run/nginx.pid

COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx.conf.template /etc/nginx/templates/default.conf.template

# Valores por defecto para docker-compose (sobreescribibles con -e al correr el contenedor)
ENV BACK_DESPACHOS_HOST=back-despachos:8081
ENV BACK_VENTAS_HOST=back-ventas:8080
ENV NGINX_RESOLVER=127.0.0.11
ENV NGINX_ENVSUBST_TEMPLATE_VARS="BACK_DESPACHOS_HOST BACK_VENTAS_HOST NGINX_RESOLVER"

USER nginx

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]