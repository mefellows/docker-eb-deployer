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
RUN /bin/bash -l -c "rvm install 1.9.3"

# Seek EB Deployer
RUN mkdir -p /opt/seek/ && \
  curl -sS "http://stash.seek.int:7990/users/pmescalchin/repos/ebdeployerpackagedeploy/browse/ebdeployer.sh?raw" -o /opt/seek/seek_eb_deployer && \
  sed -i 's/RUBY_VERSION="1.9.3"/RUBY_VERSION="2.2.1"/' /opt/seek/seek_eb_deployer && \
  chmod +x /opt/seek/seek_eb_deployer

# Latest EB Deployer
RUN yum install -y git
RUN /bin/bash -l -c "echo 'Installing eb deployer from source' && \
  mkdir -p ~/.ssh && \
  touch ~/.ssh/known_hosts && \
  ssh-keyscan github.com >> ~/.ssh/known_hosts && \
  cd /tmp && \
  git clone https://github.com/mefellows/eb_deployer.git && \
  cd eb_deployer && \
  git checkout terminate-inactive && \
  echo '2.2.1' > .ruby-version && \
  rvm use 2.2 && \
  bundle install && \
  gem build eb_deployer.gemspec && \
  gem uninstall eb_deployer -x && \
  gem install ./eb_deployer-*.gem"

ADD ./scripts/docker.sh /usr/bin/docker-run
WORKDIR /var/app
