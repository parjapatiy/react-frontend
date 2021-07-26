FROM  node:latest
ARG backend
ENV REACT_APP_BACKEND=$backend
RUN mkdir -p /home/node/yan
WORKDIR /home/node/yan
COPY . .
RUN npm install
EXPOSE 4100
CMD ["npm","start"]
