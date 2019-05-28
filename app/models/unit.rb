class Unit < ApplicationRecord
  has_many :logs, as: :loggable
  accepts_nested_attributes_for :logs, :reject_if => :all_blank, :allow_destroy => true

  validates :title, presence: true, uniqueness: true

  attr_accessor :author

  before_validation :prerequisite
  before_save :create_log

  default_scope { order(title: :asc) }

  def to_html( value: title )
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

  private

  def prerequisite
    self.html = to_html if html.blank?
    self.report = title if report.blank?
  end
end
