FROM python:3.10.0

COPY . .
RUN apt-get update && apt-get install -y fontconfig
RUN pip install cmake
RUN pip install dlib
RUN pip install -r requirements.txt



COPY ./face_finder_react/package.json /app/face_finder_react
WORKDIR /app/face_finder_react/

RUN curl -sL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get update && apt-get install -y nodejs

WORKDIR /app/

RUN npm install --prefix ./face_finder_react/
RUN npm run build --prefix ./face_finder_react/

