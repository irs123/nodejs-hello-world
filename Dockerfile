FROM node:14-alpine
ENV DIR_PATH=""
ENV ARCHIVE_DIR_PATH=""
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
CMD ["npm" , "start"]
