FROM continuumio/anaconda3
MAINTAINER david@logicalspark.com

COPY startup /opt/startup
COPY sshd_config /etc/ssh/

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends apt-utils
RUN	apt-get update \
	&& apt-get install apt-utils curl less lsof nano vim -y
# ------------------------
# SSH Server support
# ------------------------
RUN 	apt-get update \
    	&& apt-get install -y --no-install-recommends openssh-server \
    	&& echo "root:Docker!" | chpasswd

RUN 	chmod 755 /opt/startup/init_container.sh

RUN pip install textrazor
RUN pip install tika
RUN conda install gensim -y
RUN conda install flask=0.12.2

EXPOSE 2222 8888 8800
ENTRYPOINT ["/opt/startup/init_container.sh"]
