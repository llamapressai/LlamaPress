
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

## Step 3: Set up the initial route. 

Open up plugins/hello_dolly/config/routes.rb, and add a new line.

Change: 
```ruby
HelloDolly::Engine.routes.draw do
end
```

to: 
```ruby
HelloDolly::Engine.routes.draw do
    root to: "greetings#index" #<-- add this line here
end
```

## Step 4: Setting up a new controller.