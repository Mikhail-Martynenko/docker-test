# Стадия установки зависимостей
FROM node:slim as dependencies
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install

# Стадия разработки с hot reload
FROM dependencies as development
WORKDIR /app
COPY . .
EXPOSE 3000
RUN npm install nodemon -g
# Используем "npm run dev" для запуска разработки с hot reloads
#CMD ["npm", "run", "dev"]
CMD ["npm", "start"]
# Стадия сборки для продакшн
FROM dependencies as builder
COPY . .
RUN npm run build

# Стадия настройки nginx
FROM nginx:stable
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
