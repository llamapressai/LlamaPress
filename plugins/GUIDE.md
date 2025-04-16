
## Step 1: Create the plugin using the rails command. 

In the home directory, run: 
`rails plugin new hello_dolly --mountable --full`
`mv hello_dolly plugins/hello_dolly`

## Step 2: Update the Gemfile

In the LlamaPress Gemfile, change the new entry from: 
`gem "hello_dolly", path: "hello_dolly"`

to: 
`gem "hello_dolly", path: "plugins/hello_dolly"`

and then run: 
`bundle install`

## Step 3: Bundle the plugin

`cd plugins/hello_dolly`

## Modify the Rails version in the gemspec

In: `plugins/hello_dolly/hello_dolly.gemspec`

Make sure it has this line: 
`spec.add_dependency "rails", "~> 7.2.1" #this must match the version of Rails in the main app`

`bundle`

## Step 4: Scaffold the greetings controller

`cd plugins/hello_dolly`
`bundle exec rails g scaffold Greeting title:string content:text --engine=HelloDolly`

## Step 5: Set up the route in config/routes.rb

`mount HelloDolly::Engine, at: "plugins/hello_dolly"`

## Step 6: Run the migrations in the main app

Make sure you're in the main parent directory.

```bash
bundle exec rails hello_dolly:install:migrations
bundle exec rails db:migrate 
```

## Step 7: Asset Linking

In the newly plugins/hello_dolly folder, open up: 

plugins/hello_dolly/lib/hello_dolly/engine.rb:

```ruby
module HelloDolly
  class Engine < ::Rails::Engine
    isolate_namespace HelloDolly
  end
end
```

and change it to: 

```ruby
module HelloDolly
  class Engine < ::Rails::Engine
    isolate_namespace HelloDolly
    
    initializer 'hello_dolly.assets.precompile' do |app|
      app.config.assets.precompile += %w(
        hello_dolly/application.js
        hello_dolly/application.css
      )
    end

    initializer 'hello_dolly.assets.paths' do |app|
      app.config.assets.paths << root.join('app', 'assets', 'stylesheets')
      app.config.assets.paths << root.join('app', 'assets', 'javascripts')
      app.config.assets.paths << root.join('app', 'assets', 'images')
    end
  end
end
```

## Step 8: View the Greetings!

On your browser, navigate to: https://localhost:3000/hello_dolly/greetings