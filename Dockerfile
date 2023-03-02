FROM python:3.10.0

WORKDIR /app/

COPY . .
RUN apt-get update && apt-get install -y fontconfig
RUN pip install cmake
RUN pip install dlib
RUN pip install -r requirements.txt



FROM node:16-alpine

WORKDIR app/face_finder_react/

RUN npm ci
RUN npm run build

