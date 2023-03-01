FROM python:3.10.0

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

COPY . /app
RUN apt-get update && apt-get install -y fontconfig
RUN pip install cmake
RUN pip install dlib
RUN pip install -r requirements.txt

# Change directory to React app and install dependencies
WORKDIR /app/face_finder_react
# Install Node.js and npm
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get update && apt-get install -y nodejs
COPY ./face_finder_react/package.json .
COPY ./face_finder_react/package-lock.json .
RUN npm install
RUN npm run build

# Copy React app files back to Django app directory
WORKDIR /app
COPY . /app


