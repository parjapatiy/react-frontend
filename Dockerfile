
FROM  node:latest
RUN mkdir -p /home/node/yan
WORKDIR /home/node/yan
COPY . .
RUN sed -i 's/localhost/mern.squareops.xyz/' src/agent.js
RUN npm install
EXPOSE 4100
CMD ["npm","start"]
