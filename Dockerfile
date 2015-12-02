FROM centos:7.0.1406
MAINTAINER "slefort" <simon.lefort@canal-plus.com>

# Install systemd
ENV container docker
RUN yum -y remove fakesystemd
RUN yum -y install systemd
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]

# Install saltstack
ADD docker/etc.yum.repos.d/ /etc/yum.repos.d/
RUN curl -O https://repo.saltstack.com/yum/rhel7/SALTSTACK-GPG-KEY.pub
RUN rpm --import SALTSTACK-GPG-KEY.pub
RUN rm -f SALTSTACK-GPG-KEY.pub
RUN yum -y clean expire-cache
RUN yum -y update
RUN yum -y install salt-minion
RUN mkdir -p /var/log/salt

# Add custom salt files
RUN mkdir /var/log/app
ADD docker/grains /etc/salt/grains
ADD docker/minion.conf /etc/salt/minion.d/minion.conf
VOLUME [ "/app/cd-factory" ]

CMD ["/usr/sbin/init"]
