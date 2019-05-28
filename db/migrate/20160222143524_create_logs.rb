class CreateLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :logs do |t|
      t.string      :author, index: true, null: false
      t.references  :job, index: true
      t.references  :loggable, :polymorphic => true, index: true
      t.string      :action, null: false, default: ''
      t.text        :body, null: false, default: ''
      t.jsonb       :field, default: '{}'

      t.timestamps null: false
    end

    add_foreign_key :logs, :jobs, column: :job_id, primary_key: "id"
    add_index :logs, :created_at
  end
end
