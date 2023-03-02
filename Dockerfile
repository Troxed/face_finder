FROM python:3.10.0

WORKDIR /app/

COPY . .
RUN apt-get update && apt-get install -y fontconfig
RUN pip install cmake
RUN pip install dlib
RUN pip install -r requirements.txt


FROM node:16-alpine

WORKDIR /app/face_finder_react/

COPY face_finder_react .
ENV PATH /app/face_finder_react/node_modules/.bin:$PATH

RUN npm install
RUN chmod +x /app/face_finder_react/node_modules/.bin/react-scripts
RUN npm run build