class CreateUnits < ActiveRecord::Migration[5.2]
  def change
    enable_extension 'citext'

    create_table :units do |t|
      t.citext 	:title,               null: false,                  index: true, unique: true
      t.text    :body
      t.citext  :html,                              default: ''
      t.citext  :report,                            default: ''
      t.boolean :active,              null: false,  default: true,  index: true

      t.timestamps
    end

    add_foreign_key :analisy_results, :units, column: :result_unit_id, primary_key: "id", on_delete: :restrict, on_update: :cascade
    add_foreign_key :analisy_results, :units, column: :indecision_unit_id, primary_key: "id", on_delete: :restrict, on_update: :cascade
  end
end
