FROM  node:alpine3.14 as build-step
ARG backend
ENV REACT_APP_BACKEND=$backend
RUN mkdir /app
WORKDIR /app
COPY package.json /app
RUN npm install
COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=build-step /app/build  /usr/share/nginx/html
