
## Step 1: Create the plugin using the rails command. 

In the home directory, run: 
`rails plugin new hello_dolly --mountable --full`

## Step 2: Update the Gemfile

In the LlamaPress Gemfile, change the new entry from: 
`gem "hello_dolly", path: "hello_dolly"`

to: 
`gem "hello_dolly", path: "plugins/hello_dolly"`

and then run: 
`bundle install`

## Step 3: Bundle the plugin

`cd plugins/hello_dolly`

`bundle`

## Step 4: Scaffold the greetings controller

`bundle exec rails g scaffold Greeting title:string content:text --engine=HelloDolly`

## Step 5: Set up the route in config/routes.rb

`mount HelloDolly::Engine, at: "plugins/hello_dolly"`

## Step 6: Run the migrations in the main app
```bash
cd ..
bundle exec rails hello_dolly:install:migrations
bundle exec rails db:migrate 
```