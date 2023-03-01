FROM python:3.10.0

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

COPY requirements.txt /app
COPY face_finder_react /app
RUN apt-get update && apt-get install -y fontconfig
RUN pip install cmake
RUN pip install dlib
RUN pip install -r requirements.txt

# Change directory to React app and install dependencies
WORKDIR /code/face_finder_react
COPY package.json .
COPY package-lock.json .
RUN npm install
RUN npm run build

# Copy React app files back to Django app directory
WORKDIR /code
COPY arial.ttf /usr/share/fonts/truetype/
COPY . /code/


