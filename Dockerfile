FROM ubuntu:16.10

MAINTAINER Barisigara Adrian Paul <padrian.baba@gmail.com>

# Install required packages and remove the apt packages cache when done.

RUN apt-get update && \
    apt-get upgrade -y && \ 
    apt-get install -y \
	git \
	python \
	python-dev \
	python-setuptools \
	python-pip \
	nginx \
	supervisor \
	sqlite3 && \
	pip install -U pip setuptools && \
  	rm -rf /var/lib/apt/lists/*

# install uwsgi now because it takes a little while
RUN pip install uwsgi

# setup all the configfiles
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
COPY nginx-app.conf /etc/nginx/sites-available/default
COPY supervisor-app.conf /etc/supervisor/conf.d/

# COPY requirements.txt and RUN pip install BEFORE adding the rest of your code, this will cause Docker's caching mechanism
# to prevent re-installinig (all your) dependencies when you made a change a line or two in your app.

COPY app/requirements.txt /var/www/
RUN pip install -r /var/www/requirements.txt

# add (the rest of) our code
COPY . /var/www/

#EXPOSE 80 8000
CMD ["supervisord", "-n"]
