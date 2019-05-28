class AnalisyResult < ApplicationRecord
  belongs_to :analisy, :class_name => "Analisy", :foreign_key => "analisy_id" #, required: true
  belongs_to :nuclide, :class_name => "Nuclide", :foreign_key => "nuclide_id", required: true

  belongs_to :result_unit, :class_name => "Unit", :foreign_key => "result_unit_id"
  belongs_to :indecision_unit, :class_name => "Unit", :foreign_key => "indecision_unit_id"

  has_many :analisy_result_reports, :class_name => "AnalisyResultReport", source: :analisy_result
  has_many :reports, through: :analisy_result_reports, :class_name => "Report", source: :report
  accepts_nested_attributes_for :reports, :reject_if => :all_blank, :allow_destroy => true

  has_one :sample, :through => :analisy
  has_one :job, :through => :sample
  has_one :analisy_type, :through => :analisy, source: :type
    
  has_many :logs, as: :loggable
  accepts_nested_attributes_for :logs, :reject_if => :all_blank, :allow_destroy => true

  accepts_nested_attributes_for :analisy, :reject_if => :all_blank, :allow_destroy => true
  
  attr_accessor :author, :device, :import

  validates :full_result, presence: true, if: Proc.new { |result| result.absence_analysis.blank? }
  validates :full_result_with_nuclide, presence: true, if: Proc.new { |result| result.absence_analysis.blank? }
 
  validates_presence_of :result_unit_id, message: "Unità di misura mancante!", on: :update, if: Proc.new { |result| result.absence_analysis.blank? }
  validates_presence_of :indecision_unit_id, message: "Unità di misura della incertezza mancante!", on: :update, if: Proc.new { |result| result.absence_analysis.blank? }

  before_validation :prerequisite
  before_save :create_log

  scope :issued, -> { includes(:reports).issued }
  scope :notissued, -> { AnalisyResultReport.where(report_id: @job.reports.issued.ids).where.not(analisy_result_id: @job.results.ids) }

  def symbols
    [ '±', '<' ]
  end

  def nuclides
    AnalisyType.find(analisy.analisy_type_id).nuclides
  end

  def destroy
    unless reports.present?
      false
    else
      super
    end
  end

  def self.has_report?
    reports.present?
  end

  def set_results
    self.full_result = case symbol
      when "±"
        "#{result} #{result_unit.html unless result_unit_id.blank? } #{symbol} #{indecision} #{indecision_unit.html unless result_unit_id.blank?}"
      when "<"
        "#{symbol} #{result} #{result_unit.html unless result_unit_id.blank?}"
      else
        "n.d."
    end
  end

  def to_html( value = full_result_with_nuclide )
    if value.present?
      if value.downcase.include?('m2')
        value = value.gsub('m2', 'm<sup>2</sup>')
      end
      if value.downcase.include?('m3')
        value = value.gsub('m3', 'm<sup>3</sup>')
      end
      if value.downcase.include?('m-1')
        value = value.gsub('m-1', 'm<sup>-1</sup>')
      end
      if value.downcase.include?('m-2')
        value = value.gsub('m-2', 'm<sup>-2</sup>')
      end
      if value.downcase.include?('m-3')
        value = value.gsub('m-3', 'm<sup>-3</sup>')
      end
    end
    return value
  end

  def to_report( value = full_result_with_nuclide )
    value.gsub!('<sup>', '&sup')
    value.gsub!('</sup>', ';')
    return value
  end

  def for_report
    text = ''
    text += "#{nuclide.title}: " unless nuclide.blank?
    text += full_result.blank? ? 'n.d.' : "#{full_result}"
    self.full_result_with_nuclide = text
  end

  private

  def prerequisite
    if new_record? && import.blank?
      self.full_result = 'n.d.'
    else
      if absence_analysis.present?
        self.result = ''
        self.result_unit_id = :null
        self.indecision = ''
        self.indecision_unit_id = :null
        self.full_result = ''
        self.absent = true
        self.full_result = absence_analysis
      else
        errors.add :result, 'campo obbligatorio' if result.blank?
        errors.add :result_unit_id, 'campo obbligatorio' if result_unit_id.blank?
        errors.add :indecision, 'campo obbligatorio' if symbol == '±' && indecision.blank?
        errors.add :indecision_unit_id, 'campo obbligatorio' if symbol == '±' && indecision_unit_id.blank?
        if errors.blank?
          self.absent = false
        end
        set_results
      end
    end
    for_report
    self.author = analisy.try(:author) || 'System'
  end
end
