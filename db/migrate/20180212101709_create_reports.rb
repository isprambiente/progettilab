class CreateReports < ActiveRecord::Migration[5.2]
  def change
    create_table :reports do |t|
      t.string      :code,                      null: false, index: true,  default: -> { "to_char(CURRENT_TIMESTAMP, 'YYMMDDMIHH24')" }
      t.integer     :report_type,               null: false, index: true,  default: 0 # Rapporto singolo o multiplo
      t.integer     :job_id,                    null: false, index: true
      t.integer     :analisy_id,                             index: true
      t.datetime    :cancelled_at
      t.text        :cancellation_reason,       null: false,               default: ''
      t.attachment  :file,                      null: false

      t.timestamps
    end

    add_foreign_key :reports, :jobs, column: :job_id, primary_key: "id", on_delete: :restrict, on_update: :restrict
    add_foreign_key :reports, :analisies, column: :analisy_id, primary_key: "id", on_delete: :nullify, on_update: :cascade
  end
end