FROM python:3.10.0
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
WORKDIR /code
COPY requirements.txt /code/
RUN apt-get update && apt-get install -y fontconfig
RUN pip install cmake
RUN pip install dlib
RUN pip install -r requirements.txt
COPY arial.ttf /usr/share/fonts/truetype/
COPY . /code/
WORKDIR /code/face_finder_react
RUN npm install
RUN npm run build
WORKDIR /code/