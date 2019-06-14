FROM continuumio/anaconda3
MAINTAINER david@logicalspark.com

COPY startup /opt/startup
COPY sshd_config /etc/ssh/
COPY sources.list /etc/apt/sources.list.d/
RUN mkdir /opt/notebooks
COPY code /opt/notebooks

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends apt-utils
RUN	apt-get update \
	&& apt-get install apt-utils curl less lsof nano vim sudo nginx supervisor certbot -y
	&& apt-get -y install python-certbot-nginx -t stretch-backports
# ------------------------
# SSH Server support
# ------------------------
RUN 	apt-get update \
    	&& apt-get install -y --no-install-recommends openssh-server \
    	&& echo "root:Docker!" | chpasswd

RUN 	chmod 755 /opt/startup/init_container.sh

RUN conda install gensim -y
RUN conda install -c conda-forge jupyterlab -y
RUN conda install flask=0.12.2 -y

RUN pip install textrazor tika flask-cors pyopenssl azure-storage-file azure-storage-blob applicationinsights geocoder gunicorn python-rake rq flask-bootstrap flask-wtf


EXPOSE 80 2222 8888 8700-8800 9999
ENTRYPOINT ["/opt/startup/init_container.sh"]
