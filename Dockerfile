FROM ubuntu:latest
MAINTAINER writtic <writtic@gmail.com>
RUN apt-get update; apt-get install -y unzip openjdk-8-jre-headless curl supervisor docker.io openssh-server
ENV JAVA_HOME /usr/li!b/jvm/java-8-openjdk-amd64/
RUN echo 'root:1q2w3e!@#$’ | chpasswd
RUN mkdir /var/run/sshd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

EXPOSE 22
