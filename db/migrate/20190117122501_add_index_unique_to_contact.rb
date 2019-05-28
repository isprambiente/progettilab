class AddIndexUniqueToContact < ActiveRecord::Migration[5.2]
  remove_index  :job_contacts, [:job_id, :priority]
  add_index     :job_contacts, [:job_id, :priority], order: {job_id: :asc, priority: :desc, created_at: :asc, label: :asc}, unique: true
end
