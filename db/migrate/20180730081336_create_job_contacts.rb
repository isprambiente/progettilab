class CreateJobContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :job_contacts do |t|
      t.references :job, foreign_key: true
      t.string :label,   null: false, default: "" #, unique: true
      t.text :note
      t.boolean :priority, null: false, default: false
      t.jsonb :metadata

      t.timestamps
    end

    add_index :job_contacts, [:job_id, :label], unique: true, order: {job_id: :asc, label: :asc}
    add_index :job_contacts, [:job_id, :priority], order: {job_id: :asc, priority: :desc, created_at: :asc, label: :asc}
  end
end
