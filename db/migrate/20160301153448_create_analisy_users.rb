class CreateAnalisyUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :analisy_users do |t|
      t.references :analisy,      null: false, index: true
      t.references :user,         null: false, index: true
      t.integer :role,            null: false, index: true

      t.timestamps
    end

    add_foreign_key :analisy_users, :analisies, column: :analisy_id, primary_key: "id", on_delete: :cascade
    add_foreign_key :analisy_users, :users, column: :user_id, primary_key: "id", on_delete: :restrict

    add_index :analisy_users, [:analisy_id, :user_id, :role], order: { analisy_id: :asc, users_id: :asc, role: :asc }, unique: true
  end
end
