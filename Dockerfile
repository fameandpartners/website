FROM ruby:2.3.3-slim

RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main' >> /etc/apt/sources.list.d/postgresql.list

RUN apt-get update && apt-get install -qq -y wget

RUN wget --no-check-certificate -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O- | apt-key add -
RUN apt-get update && apt-get install -qq -y build-essential nodejs libpq-dev postgresql-client-9.6 git libxml2 libxml2-dev libxslt1-dev sqlite3 libsqlite3-dev imagemagick libmagickwand-dev netcat --fix-missing --no-install-recommends

ENV INSTALL_PATH /app
RUN mkdir -p $INSTALL_PATH
WORKDIR $INSTALL_PATH

ENV BUNDLE_CACHE_PATH vendor/cache

ARG CIRCLE_SHA1
ENV CIRCLE_SHA1 $CIRCLE_SHA1
ARG CIRCLE_BRANCH
ENV CIRCLE_BRANCH $CIRCLE_BRANCH
ARG CIRCLE_BUILD_NUM
ENV CIRCLE_BUILD_NUM $CIRCLE_BUILD_NUM

# Copy over Gemfile
COPY Gemfile* ./

# Copy over required local gems
COPY vendor ./vendor
COPY engines ./engines
COPY spree_masterpass ./spree_masterpass

RUN gem install bundler
RUN bundle install --local

COPY . .

# Remove git folder because docker ignore doesn't work when doing COPY
# RUN rm -rf .git

# Install new packages / git packages not in vendor cache
# RUN bundle install

# Make runnable
RUN chmod +x docker-run.sh

EXPOSE 3000

ENTRYPOINT ["/app/docker-run.sh"]
CMD ["/app/bin/unicorn", "-c", "/app/config/unicorn.rb", "-E", "echo ${RAILS_ENV}"]
