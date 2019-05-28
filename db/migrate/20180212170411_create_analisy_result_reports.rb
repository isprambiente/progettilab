class CreateAnalisyResultReports < ActiveRecord::Migration[5.2]
  def change
    create_table :analisy_result_reports do |t|
      t.references :analisy_result
      t.references :report

      t.timestamps
    end

    add_foreign_key :analisy_result_reports, :analisy_results, column: :analisy_result_id, primary_key: "id", on_delete: :cascade, on_update: :cascade
    add_foreign_key :analisy_result_reports, :reports, column: :report_id, primary_key: "id", on_delete: :restrict, on_update: :cascade

    add_index :analisy_result_reports, [:analisy_result_id, :report_id], order: {analisy_result_id: :asc, report_id: :asc}
    add_index :analisy_result_reports, [:report_id, :analisy_result_id], order: {report_id: :asc, analisy_result_id: :asc}
  end
end
