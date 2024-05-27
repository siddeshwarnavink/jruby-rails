FROM openjdk:17-slim
LABEL authors="siddeshwar"

WORKDIR /app

# Install & setup JRuby
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libvips pkg-config curl libc6-dev libffi-dev zlib1g-dev netbase
RUN curl -L https://repo1.maven.org/maven2/org/jruby/jruby-dist/9.3.0.0/jruby-dist-9.3.0.0-bin.tar.gz -o jruby-9.3.0.0.tar.gz && \
    tar -xzf jruby-9.3.0.0.tar.gz && \
    mv jruby-9.3.0.0 /usr/local/lib/jruby
ENV PATH="$PATH:/usr/local/lib/jruby/bin"
RUN ln -s /usr/local/lib/jruby/bin/jruby /usr/bin/ruby
RUN alias ruby="jruby"

# Install Node.js and YARN
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
RUN apt-get install -y nodejs yarn

ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

COPY Gemfile Gemfile.lock ./
RUN gem install bundler --no-document
RUN bundle config set --local without 'development test' && \
    bundle install --jobs=4

COPY . .

CMD ["yarn", "install"]
CMD ["SECRET_KEY_BASE_DUMMY=1", "./bin/rails", "assets:precompile"]
CMD ["./bin/rails", "db:migrate"]

EXPOSE 3000
CMD ["./bin/rails", "server"]