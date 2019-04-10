FROM ruby:2.3.8-slim-stretch

RUN for i in {1..8}; do mkdir -p "/usr/share/man/man$i"; done
RUN apt-get update && apt-get install -qq -y build-essential nodejs libpq-dev postgresql-client-9.6 git libxml2 libxml2-dev libxslt1-dev sqlite3 libsqlite3-dev imagemagick libmagickwand-dev netcat webp cron --fix-missing --no-install-recommends

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

RUN bundle exec rake RAILS_ENV=production DATABASE_URL=postgresql://user:pass@127.0.0.1/dbname SECRET_TOKEN=pickasecuretoken AWS_S3_BUCKET=fake_bucket AWS_S3_ACCESS_KEY_ID=fake_key AWS_S3_SECRET_ACCESS_KEY=fake_secret AWS_S3_REGION=us-east-1 assets:precompile

# Make runnable
RUN chmod +x docker-run.sh

EXPOSE 3000

ENTRYPOINT ["/app/docker-run.sh"]

