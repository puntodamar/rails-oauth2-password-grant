# --- Build stage ---
FROM ruby:3.1.0-slim AS builder

ARG PORT
ARG SECRET_KEY_BASE
ENV SECRET_KEY_BASE=$SECRET_KEY_BASE

RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs \
  yarn \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install


COPY . .

RUN #RAILS_ENV=production bundle exec rake assets:precompile
RUN RAILS_ENV=production ASSETS_PRECOMPILE=true bundle exec rake assets:precompile

RUN bundle clean --force

# --- Final stage ---
FROM ruby:3.1.0-slim

RUN apt-get update -qq && apt-get install -y \
  build-essential \
  ruby-dev \
  libpq-dev \
  nodejs \
  yarn \
  && rm -rf /var/lib/apt/lists/*



WORKDIR /app

COPY --from=builder /app /app

RUN bundle config set without 'development test' && bundle install
ENV TZ=Asia/Jakarta
RUN ["/bin/bash", "-c", "ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone"]
EXPOSE $PORT

#RUN chmod +x /usr/src/app/script/deploy.sh
#ENTRYPOINT /usr/src/app/script/deploy.sh

RUN chmod +x script/deploy.sh
ENTRYPOINT ["/bin/bash", "-c", "script/deploy.sh"]


