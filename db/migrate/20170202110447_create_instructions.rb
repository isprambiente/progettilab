class CreateInstructions < ActiveRecord::Migration[5.2]
  def change
    create_table :instructions do |t|
			t.string :title,                null: false,                  index: true, unique: true
      t.text :body
      t.attachment :file
      t.boolean :active,              null: false,  default: true,  index: true

      t.timestamps
    end

    add_foreign_key :analisy_types, :instructions, column: :instruction_id, primary_key: "id", on_delete: :nullify
  end
end
