class CreateMatrixTypes < ActiveRecord::Migration[5.2]
  def change
    enable_extension 'citext'

    create_table :matrix_types do |t|
      t.integer :pid
      t.citext  :title,                null: false,                  index: true
      t.text    :body
      t.integer :radia,                                              index: true
      t.boolean :active,               null: false,  default: true,  index: true

      t.timestamps
    end

    add_foreign_key :matrix_types, :matrix_types, column: :pid, primary_key: "id", on_delete: :restrict, on_update: :cascade
    add_foreign_key :samples, :matrix_types, column: :type_matrix_id, primary_key: "id", on_delete: :restrict, on_update: :cascade

    add_index :matrix_types, [:pid, :title], unique: true, order: {pid: :asc, title: :asc}
  end
end
