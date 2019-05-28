class CreateJobRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :job_roles do |t|
      t.references :job,      index: true, null: false
      t.references :user,     index: true, null: false
      t.boolean    :manager,  index: true, null: false, default: false

      t.timestamps null: false
    end

    add_foreign_key :job_roles, :jobs, column: :job_id, primary_key: "id", on_delete: :cascade
    add_foreign_key :job_roles, :users, column: :user_id, primary_key: "id", on_delete: :restrict

    add_index :job_roles, [:job_id, :user_id], order: {job_id: :asc, user_id: :asc}, unique: true
  end
end
