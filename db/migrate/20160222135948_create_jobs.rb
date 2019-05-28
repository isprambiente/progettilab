class CreateJobs < ActiveRecord::Migration[5.2]
  def change
    enable_extension 'citext'

    create_table :jobs do |t|
      t.references  :chief,                index: true, null: false
      t.string      :code,                 index: true, null: false, default: '', unique: true
      t.citext      :title,                index: true, null: false, default: '' #, unique: true
      t.integer     :version,              index: true, null: false, default: 1
      t.integer     :revision,             index: true, null: false, default: 0
      t.string      :template
      t.text        :body
      t.date        :open_at,              index: true, null: false
      t.date        :close_at,             index: true
      t.date        :planned_closure_at,   index: true
      t.boolean     :consolidated,         index: true, null: false, default: false
      t.boolean     :pa_support,           index: true, null: false, default: false
      t.integer     :n_samples,            index: true,              default: 0
      t.jsonb       :metadata
      t.integer     :status,               index: true, null: false, default: 1
      t.boolean     :timetables_validated, index: true, null: false, default: false
      t.boolean     :deleted,              index: true, null: false, default: false
      t.timestamps
    end

    add_foreign_key :jobs, :users, column: :chief_id, primary_key: "id", on_delete: :restrict
    add_index :jobs, [:open_at, :title], order: {open_at: :desc, title: :asc}
  end
end