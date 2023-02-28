FROM python:3.10.0

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /face_finder

COPY requirements.txt /face_finder/
RUN apt-get update && apt-get install -y fontconfig
RUN pip install cmake
RUN pip install dlib
RUN pip install -r requirements.txt

# Change directory to React app and install dependencies
WORKDIR /face_finder/face_finder_react

# Install Node.js and npm
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get update && apt-get install -y nodejs

COPY package.json .
COPY package-lock.json .
RUN npm install
RUN npm run build

# Move back to Django app directory
WORKDIR /face_finder

# Copy the entire "face_finder_react" directory to the Docker image
COPY face_finder_react /face_finder/face_finder_react/

# Copy other files to Django app directory
COPY arial.ttf /usr/share/fonts/truetype/
COPY . /face_finder/
