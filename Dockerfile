FROM python:3.10.0

WORKDIR /app

RUN curl -sL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get update && apt-get install -y nodejs

COPY face_finder/requirements.txt .
RUN pip install -r requirements.txt
RUN apt-get update && apt-get install -y fontconfig
RUN pip install cmake
RUN pip install dlib

COPY face_finder/ .
COPY face_finder_react/ ./face_finder_react/

ENV NODE_ENV=production

RUN cd face_finder_react && npm install
RUN cd_face_finder_react && npm run build


