FROM python:3.10.0

WORKDIR /app

RUN curl -sL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get update && apt-get install -y nodejs

COPY requirements.txt .
RUN apt-get update && apt-get install -y fontconfig
RUN pip install cmake
RUN pip install dlib
RUN pip install -r requirements.txt

COPY face_finder .
COPY face_finder_react .
COPY face_finder_react/package*.json face_finder_react

ENV NODE_ENV=production

WORKDIR app/face_finder_react

RUN npm install
RUN npm run build


