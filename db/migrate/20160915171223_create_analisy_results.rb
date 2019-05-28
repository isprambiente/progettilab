class CreateAnalisyResults < ActiveRecord::Migration[5.2]
  def change
    create_table :analisy_results do |t|
      t.references  :analisy,                     null: false,                 index: true
      t.references  :nuclide,                     null: false,                 index: true
      t.numeric     :result,                                                   index: true
      t.references  :result_unit
      t.string      :symbol,                      null: false, default: ''
      t.numeric     :indecision,                                               index: true
      t.references  :indecision_unit
      t.string      :mcr
      t.string      :doc_rif_int
      t.string      :full_result,                 null: false, default: ''
      t.string      :full_result_with_nuclide,    null: false, default: ''
      t.boolean     :absent,                      null: false, default: false, index: true
      t.text        :absence_analysis,            null: false, default: ''
      t.boolean     :active,                      null: false, default: true,  index: true
      t.text        :info
      t.text        :body

      t.timestamps
    end

    add_foreign_key :analisy_results, :analisies, column: :analisy_id, primary_key: "id", on_delete: :cascade, on_update: :cascade
    add_foreign_key :analisy_results, :nuclides, column: :nuclide_id, primary_key: "id", on_delete: :restrict, on_update: :cascade

    add_index :analisy_results, [:analisy_id, :nuclide_id, :active], unique: true, order: {analisy_id: :asc, nuclide_id: :asc}
  end
end
