FROM centos:7
MAINTAINER Carlos Sura <carlos@sendplex.com>
LABEL Description="LAMP PHP 7.2. CentOS 7" \
	Usage="linux: docker run -d -p [HOST PORT NUMBER]:80 -v [HOST WWW DOCUMENT ROOT]:/var/www/html sendplex \
	windows: docker run -it -d -p 80:80 -v E:/Workspace/dialpunch-backend:/var/www/html sendplex" \
	Version="1.0"


# Install epel
RUN yum -y install epel-release

# Install RPMs
#RUN rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN rpm -Uvh http://rpms.remirepo.net/enterprise/remi-release-7.rpm


# Install Web Server
RUN yum -y update && yum clean all
RUN yum -y install httpd
RUN yum -y install gcc make openssl-devel python34 python34-devel python34-setuptools python-pip python-setuptools

# Networking
RUN echo "NETWORKING=yes" > /etc/sysconfig/network

# Using php7.2
RUN yum-config-manager --enable remi-php72

# Install php
RUN yum install -y \
	php \
	php-common \


# Custom environment variables defined here
ENV ALLOW_OVERRIDE All
ENV DATE_TIMEZONE UTC


# Install supervisord
#RUN cd /usr/lib/python3.4/site-packages/ && python3 easy_install.py pip && pip3 install --upgrade pip
#RUN pip3 install supervisor
RUN easy_install pip
RUN pip install --upgrade pip
RUN pip install supervisor

# Adding index.php file which contains phpinfo only.
COPY . /var/www/html/

# Adding custom supervisord configuration.
ADD supervisord.conf /etc/

# Exposed ports
EXPOSE 80

# Running supervisord
CMD ["supervisord", "-n"]
