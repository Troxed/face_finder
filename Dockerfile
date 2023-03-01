# Use the official Python image as the base image
FROM python:3.9-slim-buster

# Set the working directory
WORKDIR /app

# Copy the requirements file to the container
COPY requirements.txt .

# Install fontconfig and dlib dependencies
RUN apt-get update && apt-get install -y fontconfig
RUN pip install cmake
RUN pip install dlib
RUN pip install -r requirements.txt

COPY . .

# Set the working directory to the React app directory
WORKDIR /app/face_finder/face_finder_react

# Copy package.json and package-lock.json to the container
COPY face_finder/face_finder_react/package*.json ./

# Install NPM
RUN npm install

# Build the React app
RUN npm run build

# Set the working directory back to the root directory
WORKDIR /app



