class JobContact < ApplicationRecord
  belongs_to :job, :class_name => "Job", :foreign_key => "job_id", required: true

  store_accessor :metadata, :contact, :tel1, :tel2, :fax, :cell, :email
  attr_accessor :author

  validates_presence_of :label
  validates_length_of :label, minimum: 2, too_short: I18n.t('too_short', scope:'errors', default: "%{count} characters is the minimum allowed", count: "%{count}" )
  validates_uniqueness_of :priority, :scope => :job_id, :message => lambda{ |x,y| I18n.t('exist', scope: 'jobcontacts', default: 'Principal contact just exist!') }

  default_scope { order(job_id: :asc, priority: :desc, label: :asc, created_at: :asc) }
  scope :priority,   -> { where(priority: true).first }
end
