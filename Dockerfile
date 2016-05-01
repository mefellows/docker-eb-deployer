FROM centos:latest

RUN sed -i '0,/enabled=.*/{s/enabled=.*/enabled=1/}' /etc/yum.repos.d/CentOS-Base.repo
RUN yum install -y epel-release which tar
RUN yum update -y
RUN curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
RUN echo "foo"
RUN curl -L get.rvm.io | bash -s stable
RUN source /etc/profile.d/rvm.sh
RUN /bin/bash -l -c "rvm requirements"
RUN /bin/bash -l -c "rvm install ruby"
RUN /bin/bash -l -c "gem install bundler --no-ri --no-rdoc"
RUN /bin/bash -l -c "gem install eb_deployer"
RUN /bin/bash -l -c "rvm install 1.9.3"

ADD ./scripts/docker.sh /usr/bin/docker-run
WORKDIR /var/app
