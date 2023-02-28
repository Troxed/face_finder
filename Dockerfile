FROM python:3.10.0

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /code

COPY requirements.txt /code
RUN apt-get update && apt-get install -y fontconfig
RUN pip install cmake
RUN pip install dlib
RUN pip install -r requirements.txt

# Change directory to React app and install dependencies
WORKDIR /code/face_finder_react

# Install Node.js and npm
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get update && apt-get install -y nodejs

COPY face_finder/face_finder_react/package.json .
COPY face_finder/face_finder_react/package-lock.json .
RUN npm install
COPY ../ /code
RUN npm run build

# Move back to Django app directory
WORKDIR /code

# Copy the entire "face_finder_react" directory to the Docker image
COPY face_finder_react .

# Copy other files to Django app directory
COPY arial.ttf /usr/share/fonts/truetype

