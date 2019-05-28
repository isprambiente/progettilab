class AnalisyType < ApplicationRecord
  belongs_to :instruction, :class_name => 'Instruction', :foreign_key => "instruction_id"

  has_many :analisys, :class_name => 'Analisy'
  has_many :samples, :through => :analisys, source: :sample
  has_many :jobs, :through => :sample, source: :job
  has_many :reports, :through => :analisys, source: :reports

  validates :title, presence: true, uniqueness: true
  validates :title, length: { minimum: 5, too_short: I18n.t('too_short', scope: 'errors', default: '%{count} characters is the minimum allowed', count: "%{count}")}


  attr_accessor :author

  has_many :logs, as: :loggable
  accepts_nested_attributes_for :logs, :reject_if => :all_blank, :allow_destroy => true

  before_validation :prerequisite
  before_save :create_log

  default_scope { order(title: :asc) }
  scope :radon, -> { where( radon: true ) }

  def delete
    destroy
  end

  def destroy
    analisys.present? ? update( active: false ) : super
  end

  def prerequisite
    self.author = 'System' if author.blank? || author.nil?
  end

end