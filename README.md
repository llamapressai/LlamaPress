<p align="center">
  <img src="https://service-jobs-images.s3.us-east-2.amazonaws.com/7rl98t1weu387r43il97h6ipk1l7" alt="LLamaPress Logo">
</p>

# 🦙 LLamaPress

**An Open-Sourced SaaS Builder for Non-Technical Builders**

Welcome to LLamaPress! LLamaPress combines the power of Ruby on Rails and LLMs. Whether you're a seasoned developer or just starting out, LLamaPress empowers you to build customizable software solutions without the usual overhead using Ruby on Rails.

## 📚 Table of Contents

1. [Introduction](#llamapress)
2. [Our Vision](#our-vision)
   - [Origin Story](#origin-story)
   - [Current State of Affairs](#current-state-of-affairs)
3. [Getting Started](#getting-started)
   - [Development Environment Setup](#development-environment-setup)
     - [Install Homebrew](#install-homebrew)
     - [Install mise](#install-mise)
   - [Useful Commands](#useful-commands)

# Our Vision

LLamaPress is designed for everyone—from the least technical to the most technical user. Our mission is to democratize software development, making it accessible to all.

### 🌱 Origin Story

LLamaPress was born out of necessity. At our SaaS startup/agency, we faced a common problem: users constantly needed new features and customizations. Each business had unique needs, making support expensive and complex.

To solve this, we integrated a chatbot to assist our free tier of users. As we built LLMs into the chatbot, we realized something incredible: the bot was surprisingly effective, particularly because the underlying code was built on Ruby on Rails. That was our "aha" moment, and LLamaPress was born.

### 🏁 Current State of Affairs:

We're currently using LLamaPress to build our SaaS and marketing agency, while helping new users build their own software on the platform. Join us on this journey to reshape the future of software development!

---

We’re excited to see what you’ll create with LLamaPress. Welcome aboard!

# 🚀 Getting Started

## Development Environment Setup

### Install `homebrew`

We need to install `homebrew` to manage our system dependencies.

Installation instructions: https://brew.sh/

```
# Install Ruby dependencies
brew install libyaml

# Install Postgres Dependencies
brew install gcc readline zlib curl ossp-uuid icu4c pkg-config openssl

# Install vips (for image processing)
brew install vips

# Install overmind dependencies (process manager)
brew install tmux
```

### Install `mise`

We use `mise` to manage our tools.

Installation instructions: https://mise.jdx.dev/getting-started.html

Once installed just run `mise install` from the root of the project.

#### First time setup

```
# Install dependencies (ruby, postgres, node, yarn, redis, etc.)
mise install

# Start postgres
pg_ctl start

# Create the database
rails db:create

# Run the migration
rails db:migrate

# Seed the database with organization and web pages
rails db:seed

# Start the server
rails s
```

### Run tests 
```
# Install playwright, () 
# https://justin.searls.co/posts/running-rails-system-tests-with-playwright-instead-of-selenium/
export PLAYWRIGHT_CLI_VERSION=$(bundle exec ruby -e 'require "playwright"; puts Playwright::COMPATIBLE_PLAYWRIGHT_VERSION.strip')
yarn add -D "playwright@$PLAYWRIGHT_CLI_VERSION"
yarn run playwright install

bash test/run_tests.sh
```

### Create `config/local_env.yml` and set up your llama-bot api keys
[local_env.yml](config/local_env.yml)
```
LLAMABOT_API_KEY: "sk-<your llama-bot key>"
LLAMABOT_API_URL: "<your llama-bot url>"
```

## Run the server
Then, visit `http://localhost:3000` in your browser to see the app.

### Sign into the account
username: kody@llamapress.ai
password: 123456

### Useful commands

```
# Postgres:
pg_ctl stop
pg_ctl start
pg_ctl restart
```

```
nano .git/hooks/pre-push
#!/bin/bash
# Run tests before pushing
bash test/run_tests

# Check if tests passed
if [ $? -ne 0 ]; then
    echo "Tests failed. Aborting push."
    exit 1
fi

# Allow push to continue if tests passed
exit 0
```

```
chmod +x .git/hooks/pre-push
```