# syntax=docker/dockerfile:1.4
ARG TARGETPLATFORM=linux/amd64
FROM --platform=${TARGETPLATFORM} ruby@sha256:bceec7582aaa80630bb51a04e2df3af658e64c0640c174371776928ad3bd57b4

# freeze snapshot
RUN rm -f /etc/apt/sources.list /etc/apt/sources.list.d/* \
 && echo "deb [trusted=yes] https://snapshot.debian.org/archive/debian/20240701T000000Z bookworm main contrib non-free" \
    > /etc/apt/sources.list

# anti-cache hack for Mac apple silicon
RUN printf 'Acquire::http::Pipeline-Depth "0";\nAcquire::http::No-Cache "true";\nAcquire::BrokenProxy "true";\n' \
    > /etc/apt/apt.conf.d/99fixbadproxy

# clean slate
RUN rm -rf /var/lib/apt/lists/* \
 && apt-get clean \
 && apt-get update -o Acquire::CompressionTypes::Order::=gz

# build dependencies with cache mounts
RUN --mount=type=cache,id=apt-cache,target=/var/cache/apt \
    --mount=type=cache,id=apt-lists,target=/var/lib/apt/lists \
    apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential \
      git \
      libpq-dev \
      pkg-config \
      curl \
      postgresql-client \
      nodejs \
      npm --fix-missing && \
    apt-get clean


# Configure npm
RUN npm config set fund false --global

WORKDIR /rails

# Set ENV for bundler
ENV RAILS_ENV="development" \
    BUNDLE_PATH="/usr/local/bundle" \
    BOOTSNAP_CACHE_DIR="/rails/tmp/cache/bootsnap"

# Copy Gemfiles
COPY Gemfile Gemfile.lock ./

# Copy application code
COPY . .

# Install gems
RUN bundle install

# Expose port 3000
EXPOSE 3000

CMD ["bundle", "exec", "rails", "db:prepare"]

# Start the Rails server
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]