FROM ruby:2.3.3-slim as build-env

RUN apt-get update && apt-get install -qq -y build-essential nodejs libpq-dev postgresql-client-9.4 git libxml2 libxml2-dev libxslt1-dev sqlite3 libsqlite3-dev imagemagick libmagickwand-dev --fix-missing --no-install-recommends

ENV INSTALL_PATH /app
RUN mkdir -p $INSTALL_PATH
WORKDIR $INSTALL_PATH

ENV BUNDLE_CACHE_PATH vendor/cache

# Copy over Gemfile
COPY Gemfile* ./

# Copy over required local gems
COPY vendor ./vendor
COPY engines ./engines
COPY spree_masterpass ./spree_masterpass

RUN gem install bundler
# RUN bundle install --path vendor/cache
RUN bundle install --local
# RUN bundle package

# RUN bundle exec rake db:migrate
# RUN bundle exec take cache:clear

EXPOSE 3001

COPY . .

RUN bundle install
RUN chmod +x docker-run.sh

ENTRYPOINT ["/app/docker-run.sh"]
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3001"]
