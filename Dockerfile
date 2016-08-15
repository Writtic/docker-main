FROM ubuntu:latest
MAINTAINER writtic <writtic@gmail.com>
# Install system requirements
RUN apt-get update && apt-get install -y --no-install-recommends \
    emacs24-nox \
    locales \
    openssh-server \
    pwgen \
    tmux \
    unzip \
    wget \
    # openjdk-8-jre-headless
    openjdk-8-jre-headless \
    supervisor \
    docker.io \
    xterm && \
    apt-get autoremove -y && \
    apt-get clean

# setup JAVA_HOME
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/

# configure password to root
RUN echo 'root:1q2w3e!@#$' | chpasswd

# Configure locales and timezone "Continent/City"
RUN locale-gen en_US.UTF-8 ko_KR.UTF-8 && \
    cp /usr/share/zoneinfo/Asia/Seoul /etc/localtime && \
    echo "Asia/Seoul" > /etc/timezone

RUN mkdir /var/run/sshd && \
# deactivate /etc/pam.d/sshd
    sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config && \
    sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config && \
# allow you to access this machine
    sed -ri 's/PermitRootLogin without-password/PermitRootLogin yes/g' /etc/ssh/sshd_config && \
    mkdir /root/.ssh

# setup shell environment
COPY configs/tmux/tmux.conf /root/.tmux.conf
RUN echo 'PAGER=less' >> /root/.bashrc && \
    echo 'TERM=xterm' >> /root/.bashrc && \
    echo 'PS1="\[\e[32m\]\u\[\e[m\]\[\e[32m\]@\[\e[m\]\[\e[32m\]\h\[\e[m\]\[\e[32m\]:\[\e[m\]\[\e[34m\]\W\[\e[m\] \[\e[34m\]\\$\[\e[m\] "' >> /root/.bashrc && \
    echo '#[ -z "$TMUX" ] && command -v tmux > /dev/null && tmux && exit 0' >> /root/.bashrc


EXPOSE 22
