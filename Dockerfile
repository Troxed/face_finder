FROM python:3.10.0

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

COPY package.json package-lock.json /app/

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
RUN npm run build

# Copy React app files back to Django app directory
WORKDIR /app


