FROM ruby:3.4.1

WORKDIR /app

RUN apt-get update -qq && apt-get install -y \
  build-essential \
  nodejs \
  default-mysql-client

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
