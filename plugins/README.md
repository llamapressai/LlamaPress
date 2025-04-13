# 🧩 LlamaPress Plugin Architecture

Welcome to the `plugins/` directory of LlamaPress — this is where you extend, customize, and enhance your LlamaPress instance using **modular, mountable Rails Engines**.

LlamaPress follows a plugin architecture inspired by WordPress and Devise, designed to keep the **core open-source project clean and focused**, while allowing **flexible extension** via plugins.

---

## 🧠 Philosophy

- **Open-core**: The base `llamapress/` repo provides essential functionality (page editing, AI workflows, etc.).
- **Extensible**: Plugins add optional features like CRMs, PPC dashboards, agentic workflows, analytics, billing, etc.
- **Isolated**: Each plugin is a self-contained [Rails Engine](https://guides.rubyonrails.org/engines.html) — namespaced, mountable, and modular.

---

## 🔧 Plugin Examples

Plugins are located in:

llamapress/plugins/ ├── llamapress_marketing_dashboard/ ├── llamapress_crm/ └── README.md

Each plugin lives in its own folder and follows the Rails Engine pattern.

---

## 🚀 How to Create Your Own Plugin

You can create your own plugin using the Rails plugin generator.

### 1. Generate a Mountable Engine

```bash
cd plugins/
rails plugin new my_plugin --mountable
```

This will create a new folder my_plugin/ with the necessary structure.

2. Define Functionality
Use your new engine just like a Rails app:

Add models, controllers, views, routes, and assets inside my_plugin/

Namespace everything inside MyPlugin::

Example model:

```ruby
# plugins/my_plugin/app/models/my_plugin/contact.rb
module MyPlugin
  class Contact < ApplicationRecord
  end
end
```

3. Mount Your Plugin in routes.rb
Edit the main app’s config/routes.rb:

mount MyPlugin::Engine, at: '/my-plugin'
Now your plugin’s routes will be available at /my-plugin.

4. Install Plugin Migrations
If your plugin defines models or database tables, copy the migrations to the main app:

```bash
rails my_plugin:install:migrations
rails db:migrate
```

5. Extend Core Models (Optional)
If your plugin needs to extend models from LlamaPress (like User, Page, etc.), use a safe patching pattern:

```ruby
# plugins/my_plugin/lib/my_plugin/patches/user_patch.rb
module MyPlugin
  module UserPatch
    extend ActiveSupport::Concern

    included do
      has_one :plugin_profile, class_name: 'MyPlugin::Profile'
    end
  end
end
```

Then, in your engine:


```ruby
# plugins/my_plugin/lib/my_plugin/engine.rb
initializer 'my_plugin.extend_user' do
  ActiveSupport.on_load(:active_record) do
    ::User.include MyPlugin::UserPatch
  end
end
```

✅ This avoids modifying the LlamaPress core directly, keeping things modular.

📚 Best Practices
Namespace all your models, controllers, and views under your engine.

Don’t modify core files — use concerns and initializers instead.

Use allow_nil: true when delegating to avoid edge-case errors.

Document your plugin with a README.md inside your plugin folder.

Prefer new tables over modifying existing core tables.

🧩 Want to Share Your Plugin?
If you’ve built something useful, we’d love to see it!

Open a pull request to this repo with your plugin added to plugins/

Or publish it as a standalone gem and share it with the community

📂 Plugin Directory Structure
Here’s what a plugin folder might look like:

```bash
plugins/
└── llamapress_example_plugin/
    ├── app/
    │   ├── controllers/
    │   ├── models/
    │   └── views/
    ├── config/
    │   └── routes.rb
    ├── db/
    │   └── migrate/
    ├── lib/
    │   └── llamapress_example_plugin/
    │       └── engine.rb
    ├── llamapress_example_plugin.gemspec
    └── README.md
```

📞 Need Help?

Join our community Discord (coming soon) or open an issue in the repo. We’re excited to see what you build.

[Discord Channel](https://discord.com/invite/7DapkvmWKZ)

Let’s grow this ecosystem together.

— LlamaPress Core Team