#!/usr/bin/env bash

apt-get -y install build-essential ruby-dev fortune

curl -sSL https://get.rvm.io | bash -s $1

/usr/local/rvm/bin/rvm install ruby

gem install bundler

usermod -a -G rvm vagrant

su - vagrant -c 'echo "source /etc/profile.d/rvm.sh" >> /home/vagrant/.bashrc'
su - vagrant -c 'source /home/vagrant/.bashrc'
su - vagrant -c 'rvm use --default ruby'
su - vagrant -c 'cd /vagrant; bundle install'
