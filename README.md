# docker-main
Contents of ```docker-main``` Dockerfile

```dockerfile
FROM ubuntu:latest
MAINTAINER writtic <writtic@gmail.com>
# Installing the 'apt-utils' package gets rid of the 'debconf: delaying package configuration, since apt-utils is not installed'
# error message when installing any other package with the apt-get package manager.
# RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
#     apt-utils && \
#     rm -rf /var/lib/apt/lists/*
# RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
#     ca-certificates \
#     && rm -rf /var/lib/apt/lists/*
# Install system requirements
RUN apt-get update && apt-get upgrade && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    # emacs24-nox \
    locales \
    openssh-server \
    # pwgen \
    tmux \
    unzip \
    wget \
    openjdk-8-jre-headless \
    supervisor \
    docker.io \
    xterm && \
    apt-get autoremove -y && \
    apt-get clean

# Setup JAVA_HOME
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/

# Configure password to root
RUN echo 'root:1q2w3e!@#$' | chpasswd

# Configure locales and timezone "Continent/City"
RUN locale-gen en_US.UTF-8 ko_KR.UTF-8 && \
    cp /usr/share/zoneinfo/Asia/Seoul /etc/localtime && \
    echo "Asia/Seoul" > /etc/timezone

RUN mkdir /var/run/sshd && \
# Deactivate /etc/pam.d/sshd
    sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config && \
    sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config && \
# Allow you to access this machine
    sed -ri 's/PermitRootLogin without-password/PermitRootLogin yes/g' /etc/ssh/sshd_config && \
    mkdir /root/.ssh

# Setup shell environment
COPY configs/tmux/tmux.conf /root/.tmux.conf
RUN echo 'PAGER=less' >> /root/.bashrc && \
    echo 'TERM=xterm' >> /root/.bashrc && \
    echo 'PS1="\[\e[32m\]\u\[\e[m\]\[\e[32m\]@\[\e[m\]\[\e[32m\]\h\[\e[m\]\[\e[32m\]:\[\e[m\]\[\e[34m\]\W\[\e[m\] \[\e[34m\]\\$\[\e[m\] "' >> /root/.bashrc && \
    echo '#[ -z "$TMUX" ] && command -v tmux > /dev/null && tmux && exit 0' >> /root/.bashrc


EXPOSE 22
```
