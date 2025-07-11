#!/bin/bash
set -e

# Pull submodules if missing
if [ ! -d "vendor/gems/llama_bot_rails/.git" ]; then
  echo "== Initializing git submodules =="
  git submodule update --init --recursive
fi

# Install Ruby gems
bundle check || bundle install

# Copy .env.example if .env is missing
if [ ! -f ".env" ]; then
  echo "== Copying .env.example to .env =="
  cp .env.example .env
fi

# Prepare DB (runs migrations, creates if needed)
bin/rails db:prepare

# Remove logs/tempfiles (optional)
bin/rails log:clear tmp:clear

# Start the server (or whatever command Docker passes)
exec "$@"
