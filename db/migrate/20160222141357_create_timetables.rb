class CreateTimetables < ActiveRecord::Migration[5.2]
  def change
    enable_extension 'citext'

    create_table :timetables do |t|
      t.references :job,        index: true, null: false
      t.integer :parent_id,     index: true
      t.citext :title,          index: true, null: false, default: ''
      t.text :body,                          null: false, default: ''
      t.date :start_at,         index: true, null: false
      t.date :stop_at,          index: true, null: false
      t.integer :days,          index: true, null: false
      t.float :progress,        index: true, null: false, default: 0
      t.text :products,                      null: false, default: ''
      t.date :execute_at,       index: true
      t.boolean :restrict,      index: true, null: false, default: false
      t.boolean :important,     index: true, null: false, default: false
      # t.boolean :validated,     index: true, null: false, default: false
      t.boolean :closed,        index: true, null: false, default: false
      t.integer :sortorder,     index: true
      # t.integer :linktype,      index: true
      t.string :color,          index: true

      t.timestamps null: false
    end

    add_foreign_key :timetables, :jobs, column: :job_id, primary_key: "id", on_delete: :cascade
    add_foreign_key :timetables, :timetables, column: 'parent_id', on_delete: :nullify
    add_index :timetables, [:parent_id, :id], order: {parent_id: :asc, id: :asc}, unique: true
    # add_index :timetables, [:id, :parent_id], order: {parent_id: :asc, id: :asc}, unique: true
    add_index :timetables, [:job_id, :title], order: {job_id: :asc, title: :asc}, unique: true

  end
end