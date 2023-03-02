FROM python:3.10.0

WORKDIR /app/

COPY . .
RUN apt-get update && apt-get install -y fontconfig
RUN pip install cmake
RUN pip install dlib
RUN pip install -r requirements.txt




WORKDIR app/face_finder_react/

RUN curl -sL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get update && apt-get install -y nodejs


RUN npm install
RUN npm run build

