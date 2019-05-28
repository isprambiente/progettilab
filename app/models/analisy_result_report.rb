class AnalisyResultReport < ApplicationRecord
  belongs_to :analisy_result, :class_name => "AnalisyResult", :foreign_key => "analisy_result_id", required: true #, validate: true
  belongs_to :report, :class_name => "Report", :foreign_key => "report_id" #, required: true #, validate: true

  has_one    :analisy, :through => :analisy_result, source: :analisy
  has_one    :job, :through => :report, source: :job

  validates_uniqueness_of :report_id, scope: :analisy_result_id, conditions: -> { joins(:report).where( 'reports.cancelled_at is null' )}, :message => "esiste già un report valido per questo risultato!"

  private

  def has_report_issued?
    report.issued.present?
  end
end
