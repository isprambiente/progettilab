class Timetable < ApplicationRecord
  belongs_to :job, :class_name => "Job", :foreign_key => "job_id"
  belongs_to :parent, :class_name => "Timetable", :foreign_key => "parent_id"

  has_many :attachments, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :attachments, :reject_if => :all_blank, :allow_destroy => true

  attr_accessor :author, :upd_rev

  has_many :logs, as: :loggable
  accepts_nested_attributes_for :logs, :reject_if => Proc.new { |attributes| attributes['author'].blank? }, :allow_destroy => true

  before_save :create_log
  after_save :update_revision, on: :update
  before_validation :prerequisite

  validates :title, presence: true, uniqueness: { scope: [:job_id] }
  validates :title, length: { minimum: 5, too_short: "#{I18n.t('too_short', scope: 'errors', default: '%{count} characters is the minimum allowed', count: "%{count}")}" }, :unless => Proc.new { |job| job.title.blank? }
  # validates :days, presence: true, :if => Proc.new { |job| job.start_at.present? && job.stop_at.present? }
  # validates :days, numericality: { only_integer: true, greater_than_or_equal_to: 0, message: "#{I18n.t('greater_than_or_equal_to', scope: 'errors.timetable', default: '^The stop at not been less than start at', count: "%{count}")}" }, :if => Proc.new { |job| job.start_at.present? && job.stop_at.present? }
  validates :sortorder, numericality: { only_integer: true, greater_than: 0, message: "#{I18n.t('greater_than_or_equal_to', scope: 'errors.timetable', default: '^The stop at not been less than start at', count: "%{count}")}" }

  validates :start_at, presence: true, date: { before_or_equal_to: :stop_at }
  validates :stop_at, presence: true, date: { after_or_equal_to: :start_at }
  validates :execute_at, date: { allow_blank: true, after_or_equal_to: :start_at }
  

  default_scope { order(sortorder: :asc, title: :asc) }
  scope :opened, -> { where( closed: false ) }
  scope :closed, -> { where( closed: true ) }

  def start_on
    I18n.l start_at.to_date if start_at.present?
  end

  def stop_on
    I18n.l stop_at.to_date if stop_at.present?
  end

  def execute_on
    I18n.l execute_at.to_date if execute_at.present?
  end

  def restrict_translated
    I18n.t "#{restrict}"
  end

  def status
    if stop_at >= (Date.today) && stop_at <= (Date.today + 5.days)
      'expiring'
    elsif stop_at < (Date.today)
      'expired'
    elsif stop_at > (Date.today)
      'intime'
    end
  end

  def timetable_expired
    TimetableMailer.expired(job).deliver_later
  end

  def next_order
    return ( Timetable.where(job_id: job.id).maximum(:sortorder).to_i + 1 ) || ( Timetable.where(job_id: job.id).count + 1 )
  end

  private

    def prerequisite
      self.author = 'System' if author.blank? || author.nil?
      self.days = ( ( stop_at - start_at ) - 1 ) if start_at.present? && stop_at.present? && ( start_at_changed? || stop_at_changed? )
      self.progress = progress/100 if progress > 1
      self.sortorder = next_order if sortorder.blank?
      
      self.upd_rev = true if persisted? && ( sortorder_changed? || title_changed? || start_at_changed? || stop_at_changed? || days_changed? || products_changed? )

    end

    def update_revision
      job.update_column :revision, job.revision + 1 if upd_rev == true
    end

end
