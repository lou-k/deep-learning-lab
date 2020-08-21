FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04
ENV LANG C.UTF-8

# A more simplified version of most of the stuff in https://github.com/ufoym/deepo/blob/master/docker/Dockerfile.mxnet-py36-cu100
COPY requirements.txt /tmp/requirements.txt
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update  && \
    apt-get install -y python3.7 python3.7-dev python3-distutils-extra screen git psmisc systemd systemd-sysv openssh-server vim nano iputils-ping curl wget rsync htop && \
    ln -s /usr/bin/python3.7 /usr/local/bin/python && \
    wget -O /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py && \
    python3.7 /tmp/get-pip.py && \
    pip install -r /tmp/requirements.txt && \
    # Cleanup
    apt-get remove -y wget && \
    ldconfig && \
    apt-get clean -y && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* \
        /tmp/* \
        /etc/apt/sources.list.d/cuda.list \
        /etc/apt/sources.list.d/nvidia-ml.list

# Adapted from https://github.com/coreweave/cuda-ssh-server/blob/master/Dockerfile
# Set up sshd
RUN mkdir /var/run/sshd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN cd /lib/systemd/system/sysinit.target.wants/ \
    && ls | grep -v systemd-tmpfiles-setup | xargs rm -f $1

RUN rm -f /lib/systemd/system/multi-user.target.wants/* \
    /etc/systemd/system/*.wants/* \
    /lib/systemd/system/local-fs.target.wants/* \
    /lib/systemd/system/sockets.target.wants/*udev* \
    /lib/systemd/system/sockets.target.wants/*initctl* \
    /lib/systemd/system/basic.target.wants/* \
    /lib/systemd/system/anaconda.target.wants/* \
    /lib/systemd/system/plymouth* \
    /lib/systemd/system/systemd-update-utmp*


COPY bg-services.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/bg-services.sh

EXPOSE 22
CMD ["/lib/systemd/systemd"]