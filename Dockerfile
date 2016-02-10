#Docker for Rails App using Nginx and Puma

#Select ubuntu as the base image
FROM seapy/ruby:2.2.0

#Install nginx, node and curl
RUN apt-get update -q
RUN apt-get install -qy nginx
RUN apt-get install -qy curl
RUN apt-get install -qy nodejs
RUN apt-get install -y --force-yes libpq-dev
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

RUN chown -R www-data:www-data /var/lib/nginx

# Install Gems
RUN gem install bundler
RUN gem install foreman
RUN gem install rails

# Add configuration files in repository to filesystem
ADD config/container/nginx-sites.conf /etc/nginx/sites-enabled/default

#Add rails project to project directory
ADD ./ /rails

# Set WORKDIR
WORKDIR /rails

ENV RAILS_ENV production
ENV PORT 8080

#bundle install
RUN /bin/bash -l -c "bundle install --without development test"

#publish port 8080
EXPOSE 8080

#Startup commands
CMD bundle exec rake db:create db:migrate assets:precompile && foreman start -f Procfile






















