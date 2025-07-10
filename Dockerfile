# syntax = docker/dockerfile:1

# This Dockerfile is designed for production, not development. Use with Kamal or build'n'run by hand:
# docker build -t my-app .
# docker run -d -p 80:80 -p 443:443 --name my-app -e RAILS_MASTER_KEY=<value from config/master.key> my-app

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG RUBY_VERSION=3.3.5
FROM ruby:$RUBY_VERSION-slim-bookworm AS base

# freeze snapshot for reproducible builds
RUN rm -f /etc/apt/sources.list /etc/apt/sources.list.d/* \
 && echo "deb [trusted=yes] https://snapshot.debian.org/archive/debian/20240701T000000Z bookworm main contrib non-free" \
    > /etc/apt/sources.list

# anti-cache hack for Mac apple silicon
RUN printf 'Acquire::http::Pipeline-Depth "0";\nAcquire::http::No-Cache "true";\nAcquire::BrokenProxy "true";\n' \
    > /etc/apt/apt.conf.d/99fixbadproxy

# Rails app lives here
WORKDIR /rails

# Install base packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl postgresql-client && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

# Throw-away build stage to reduce size of final image
FROM base AS build

# clean slate for apt
RUN rm -rf /var/lib/apt/lists/* \
 && apt-get clean \
 && apt-get update -o Acquire::CompressionTypes::Order::=gz

# Install packages needed to build gems and assets
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential \
      git \
      libpq-dev \
      pkg-config \
      nodejs \
      npm --fix-missing && \
    npm install -g yarn && \
    apt-get clean

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Install node modules
COPY package.json yarn.lock ./
RUN yarn install --production

# Copy application code
COPY . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# Final stage for app image
FROM base

# Copy built artifacts: gems, application, node_modules
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# Run and own only the runtime files as a non-root user for security
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER 1000:1000

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["./bin/rails", "server"]
