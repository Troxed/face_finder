FROM python:3.10.0

WORKDIR /app

RUN curl -sL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get update && apt-get install -y nodejs

RUN pip install -r requirements.txt
RUN apt-get update && apt-get install -y fontconfig
RUN pip install cmake
RUN pip install dlib
COPY requirements.txt .

COPY face_finder/ .
COPY face_finder_react/ ./face_finder_react/
COPY face_finder_react/package*.json .

ENV NODE_ENV=production

RUN cd face_finder_react && npm install
RUN cd_face_finder_react && npm run build



