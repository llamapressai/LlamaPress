<p align="center">
  <img src="https://service-jobs-images.s3.us-east-2.amazonaws.com/7rl98t1weu387r43il97h6ipk1l7" alt="LLamaPress Logo">
</p>

# 🦙 LlamaPress

## 🚀 Quickstart: 

```
bash bin/init
docker-compose up
``

** A Modern LLM Powered Playground **

Welcome to LLamaPress! LLamaPress combines the power of Ruby on Rails and LLMs. Whether you're a seasoned developer or just starting out, LlamaPress empowers you to build customizable software solutions without the usual overhead using Ruby on Rails.

## 📚 Table of Contents

- [🦙 LlamaPress](#-llamapress)
  - [📚 Table of Contents](#-table-of-contents)
- [Our Vision](#our-vision)
    - [🌱 Origin Story](#-origin-story)
    - [🏁 Current State of Affairs:](#-current-state-of-affairs)
- [🚀 Getting Started](#-getting-started)
  - [Development Environment Setup](#development-environment-setup)
  - [Run the server](#run-the-server)
    - [Sign into the account](#sign-into-the-account)

# Our Vision

LlamaPress is designed for everyone—from the least technical to the most technical user. Our mission is to democratize software development, making it accessible to all.

### 🌱 Origin Story

LlamaPress was born out of necessity. At our SaaS startup/agency, we faced a common problem: users constantly needed new features and customizations. Each business had unique needs, making support expensive and complex.

To solve this, we integrated a chatbot to assist our free tier of users. As we built LLMs into the chatbot, we realized something incredible: the bot was surprisingly effective, particularly because the underlying code was built on Ruby on Rails. That was our "aha" moment, and LlamaPress was born.

### 🏁 Current State of Affairs:

We're currently using LlamaPress to build our SaaS and marketing agency, while helping new users build their own software on the platform. Join us on this journey to reshape the future of software development!

---

We’re excited to see what you’ll create with LlamaPress. Welcome aboard!

# 🚀 Getting Started

## Development Environment Setup

```
#Set up llama_bot_rails in vendor/gems/llama_bot_rails
git submodule add git@github.com:kodykendall/llama_bot_rails.git vendor/gems/llama_bot_rails
cp .env.example .env
docker-compose build
docker-compose up
```

## Run the server
Then, visit `http://localhost:3000` in your browser to see the app.

### Sign into the account
username: kody@llamapress.ai
password: 123456