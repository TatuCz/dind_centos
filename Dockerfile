FROM centos:latest
MAINTAINER AixC

# Systemd integration
# See : https://marketplace.automic.com/details/centos-official-docker-image
ENV container docker
RUN yum -y swap -- remove fakesystemd -- install systemd systemd-libs
RUN yum -y update; yum clean all; \
(cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

# Install Docker CE
RUN yum install -y yum-utils \
        device-mapper-persistent-data \
        lvm2
        
RUN yum-config-manager \
        --add-repo \
        https://download.docker.com/linux/centos/docker-ce.repo

RUN yum install -y docker-ce

# Install the magic wrapper.
ADD ./wrapdocker /usr/local/bin/wrapdocker
RUN chmod +x /usr/local/bin/wrapdocker

# Start docker service automatically
RUN systemctl enable docker.service

# Define additional metadata for our image.
VOLUME [ "/sys/fs/cgroup" ]
CMD ["wrapdocker", "/usr/sbin/init"]
