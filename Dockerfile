FROM python:3.10.0
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
WORKDIR /code
COPY requirements.txt /code/
RUN pip install cmake
RUN pip install dlib
RUN pip install -r requirements.txt
RUN apt-get update && \
    apt-get install -y fontconfig fontconfig-config fonts-dejavu-core fonts-liberation2 ttf-mscorefonts-installer
COPY arial.ttf /usr/share/fonts/truetype/
RUN fc-cache -f -v
COPY . /code/