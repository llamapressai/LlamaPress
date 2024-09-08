# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

mise install
rails db:create

# create config/local_env.yml and set up your openai and claude api keys
[local_env.yml](config/local_env.yml)
```
OPENAI_API_TOKEN: "sk-<your openai key>"
CLAUDE_API_TOKEN: "sk-ant-api03-<your claude key>"
```

# put the llamabot library in lib. Full path: lib/llama_bot
[llama_bot](lib/llama_bot)

# run the migration
rails db:migrate

# seed the database with organization andweb pages
rails db:seed

# run the server
rails s