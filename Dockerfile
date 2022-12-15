FROM jenkins/jenkins:lts

#id -u jenkins
ARG HOST_UID=1001
#getent group | grep docker
ARG HOST_GID=999

USER root
RUN apt-get update  \
    && apt-get upgrade -y  \
    && apt-get -y install  \
        ca-certificates \
        curl \
        gnupg \
        lsb-release \
    && mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
    && echo \
         "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
         $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-get update \
    && apt-get -y install  \
        docker-ce  \
        docker-ce-cli  \
        containerd.io  \
        docker-compose-plugin \
    && apt-get clean autoclean  \
    && apt-get autoremove  \
    && rm -rf /var/lib/{apt,dpkg,cache,log}

RUN usermod -u $HOST_UID jenkins
RUN groupmod -g $HOST_GID docker
RUN usermod -aG docker jenkins

USER jenkins