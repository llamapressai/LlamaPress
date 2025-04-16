# This migration comes from hello_dolly (originally 20250413203845)
class CreateHelloDollyGreetings < ActiveRecord::Migration[7.2]
  def change
    create_table :hello_dolly_greetings do |t|
      t.string :title
      t.text :content

      t.timestamps
    end
  end
end
