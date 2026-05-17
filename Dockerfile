FROM node:20-alpine AS builder

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci --silent

ARG VITE_API_URL=http://localhost:8081
ENV VITE_API_URL=$VITE_API_URL

COPY . .
RUN npm run build

FROM nginx:1.27-alpine

RUN chown -R nginx:nginx /var/cache/nginx /var/run /var/log/nginx && \
    chmod -R 755 /var/cache/nginx && \
    touch /run/nginx.pid && \
    chown nginx:nginx /run/nginx.pid

COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

USER nginx

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]