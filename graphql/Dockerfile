FROM ruby:2.6-rc-alpine
ENV RACK_ENV=production
WORKDIR /app
COPY app/Gemfile* /app/
RUN bundle install --clean --without development test
COPY app /app
CMD ["bundle","exec","rackup"]