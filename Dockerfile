FROM python:3.10.0
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Install Node.js and npm
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get update && apt-get install -y nodejs

WORKDIR /code

COPY requirements.txt /code/
RUN apt-get update && apt-get install -y fontconfig
RUN pip install cmake
RUN pip install dlib
RUN pip install -r requirements.txt

# Change directory to React app and install dependencies
WORKDIR /code/face_finder_react/
COPY /face_finder_react/package.json .
COPY /face_finder_react/package-lock.json .
RUN npm install

# Copy React app files back to Django app directory
WORKDIR /code
COPY arial.ttf /usr/share/fonts/truetype/
COPY . /code/