# LlamaBot Extensions

Welcome to the **LlamaBot Extensions** folder! This directory is where you can create and manage custom extensions to enhance the capabilities of LlamaBot, our AI-powered agent. These extensions allow you to define specific tasks or workflows that LlamaBot can execute, enabling deep customization and integration with your unique needs.

## What Are LlamaBot Extensions?

LlamaBot Extensions are user-defined modules that extend the functionality of LlamaBot. These extensions allow you to:
1. **Define Specific Tasks:** Create custom actions for LlamaBot to perform, such as interacting with third-party APIs, accessing specific data in the LlamaPress database, or automating complex workflows.
2. **Provide Contextual Information:** Equip LlamaBot with detailed information about the extension, helping it make informed decisions about when and how to use it.
3. **Tailor Functionality:** Adapt LlamaBot to meet your business or application requirements with minimal effort.

## How Do LlamaBot Extensions Work?

LlamaBot uses a plugin-like system to identify and interact with extensions. Each extension is a Ruby class that follows a specific structure, providing:
- **A `run` Method:** The core task logic that LlamaBot will execute.
- **Metadata:** Information about the extension, such as its name, description, and decision-making guidelines for LlamaBot.

When LlamaBot determines that a task matches the conditions for an extension, it will call the extension’s `run` method to execute the logic.

## Getting Started

### 1. Creating an Extension

To create a new LlamaBot Extension:
1. Navigate to the `llamabot_extensions/` directory.
2. Create a new Ruby file (e.g., `my_custom_task.rb`).
3. Define a class that implements the required structure.

Example:
```ruby
# llamabot_extensions/my_custom_task.rb
class MyCustomTask < LlamaBotExtension
  # Metadata about the extension
  def self.metadata
    {
      name: "My Custom Task",
      description: "A task that demonstrates how to interact with a third-party API.",
      conditions: "Use this task when the user mentions 'custom task' or a related keyword."
    }
  end

  # The core logic of the task
  def self.run(context)
    # Access context passed by LlamaBot, e.g., user input or task parameters
    input = context[:input]

    # Example task logic (e.g., API call, database query)
    "You asked for '#{input}', here's the result from the custom task!"
  end
end
```