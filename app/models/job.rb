class Job < ApplicationRecord
  belongs_to :chief, :class_name => "User", :foreign_key => "chief_id"
  enum status: { closed: 0, intime: 1, expiring: 2, expired: 3 }
  
  has_many :roles, :class_name => 'JobRole', dependent: :destroy, inverse_of: :job
  #has_many :roles_admins, -> { where admin: true }, :class_name => 'JobRole', inverse_of: :job, before_add: [Proc.new {|p,d| d.admin = true} ], dependent: :destroy
  has_many :roles_managers, -> { where manager: true }, :class_name => 'JobRole', inverse_of: :job, before_add: [Proc.new {|p,d| d.manager = true} ], dependent: :destroy
  has_many :roles_technicians, -> { where manager: false }, :class_name => 'JobRole', inverse_of: :job, before_add: [Proc.new {|p,d| d.manager = false} ], dependent: :destroy
  has_many :job_admins, :through => :roles_admins, source: :user # , after_add: [Proc.new {|job,user| JobRole.role_created(job, user, job.author, 'chief') unless job.skip_mail == 'true'} ], after_remove: [Proc.new {|job,user| JobRole.role_removed(job, user, job.author, 'chief')  unless job.skip_mail == 'true' } ]
  has_many :job_managers, :through => :roles_managers, source: :user #, after_add: [Proc.new {|job,user| JobRole.role_created(job, user, job.author, 'manager')  unless job.skip_mail == 'true' } ], after_remove: [Proc.new {|job,user| JobRole.role_removed(job, user, job.author, 'manager')  unless job.skip_mail == 'true' } ]
  has_many :job_technicians, :through => :roles_technicians, source: :user #, after_add: [Proc.new {|job,user| JobRole.role_created(job, user, job.author, 'technic')  unless job.skip_mail == 'true' } ], after_remove: [Proc.new {|job,user| JobRole.role_removed(job, user, job.author, 'technic')  unless job.skip_mail == 'true' } ]
  accepts_nested_attributes_for :roles, :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :roles_managers, :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :roles_technicians, :reject_if => :all_blank, :allow_destroy => true

  has_many :contacts, :class_name => "JobContact", :foreign_key => "job_id"  # , as: :loggable
  accepts_nested_attributes_for :contacts, :reject_if => proc { |attributes| attributes['label'].blank? }, :allow_destroy => true

  has_many :logs, :class_name => "Log", :foreign_key => "job_id"  # , as: :loggable
  accepts_nested_attributes_for :logs, :reject_if => :all_blank, :allow_destroy => true

  has_many :timetables, :class_name => 'Timetable', dependent: :destroy
  accepts_nested_attributes_for :timetables, :reject_if => :all_blank, :allow_destroy => true

  has_many :samples, :class_name => 'Sample', dependent: :destroy
  accepts_nested_attributes_for :samples, :reject_if => :all_blank, :allow_destroy => true

  has_many :analisies, :through => :samples, :class_name => 'Analisy', dependent: :destroy
  accepts_nested_attributes_for :analisies, :reject_if => :all_blank, :allow_destroy => true

  has_many :attachments, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :attachments, :reject_if => :all_blank, :allow_destroy => true

  has_many :results, :through => :analisies, source: :results, :class_name => 'AnalisyResult', dependent: :destroy

  has_many :result_reports, :through => :results, source: :analisy_result_reports, :class_name => 'AnalisyResultReport', dependent: :destroy

  has_many :reports, -> { issued }, :class_name => 'Report', dependent: :destroy
  
  has_many :report_results, :through => :reports, source: :results

  has_many :report_analisies, :through => :reports, source: :analisies
  has_many :report_samples, :through => :reports, source: :samples

  store_accessor :metadata, :customer, :address, :latitude, :longitude, :contact, :tel1, :tel2, :fax, :cell, :email, :institutions, :requirements, :other_resources, :free #, :template
  attr_accessor :author, :skip_mail, :consolidated_changed, :skip_presence, :create_samples, :create_analisies, :analisies_list, :reopen_reason, :log_body, :unlock_validation_reason #, :status_changed

  before_validation :prerequisite

  validates :code, presence: true, uniqueness: { case_sensitive: false }, numericality: true, :unless => Proc.new { |job| job.code.blank? }
  validates_presence_of :title
  validates_uniqueness_of :title, conditions: -> { opened } #, if: :exist_title_into_opened?
  validates_length_of :title, minimum: 5, too_short: I18n.t('too_short', scope:'errors', default: "%{count} characters is the minimum allowed", count: "%{count}" )
  validates :chief_id, presence: true
  validates :job_manager_ids, presence: true
  validates :consolidated, inclusion: { in: [ true, false ] }
  validates :consolidated, exclusion: { in: [nil] }
  validates :pa_support, inclusion: { in: [ true, false ] }
  validates :pa_support, exclusion: { in: [nil] }
  validates :status, presence: true
  
  validates :open_at, presence: true, date: { before_or_equal_to: :planned_closure_at }
  validates :close_at, date: { allow_blank: true, after_or_equal_to: :open_at }
  validates :planned_closure_at, presence: true, date: { after_or_equal_to: :open_at }


  validates_associated :roles_managers, :roles_technicians

  before_save :create_log

  default_scope { where(deleted: false).order(title: :asc) }
  scope :opened,   -> { where("jobs.close_at is null").where(deleted: false) }
  scope :created_in, ->(year) { where( "extract(YEAR from created_at ) = ?", year ) }

  def opened?
    close_at.blank?
  end

  def closed?
    close_at.present?
  end

  def open_on
    open_at.present? ? I18n.l( open_at.to_date ) : ''
  end

  def close_on
    close_at.present? ? I18n.l( close_at.to_date ) : ''
  end

  def planned_closure_on
    planned_closure_at.present? ? I18n.l( planned_closure_at.to_date ) : ''
  end

  def delete
    destroy
  end

  def exist_title_into_opened?
    Job.opened.find_by(title: title).present?
  end

  def destroy
    if deleted?
      super
    else
      update(deleted: true)
    end
  end

  def role?(user)
    if user.admin?
      'admin'
    elsif chief_id == user.id
      'chief'
    elsif job_managers.where(id: user.id).present?
      'manager'
    elsif job_technicians.where(id: user.id).present?
      'technician'
    else
      'error'
    end
  end

  def job_type
    consolidated? ? 'consolidated' : 'notconsolidated'
  end

  def reopen
    update( close_at: nil )
  end

  def get_status
    new_status = 
      if close_at.present?
        'closed'
      else
        if planned_closure_at.present?
          if planned_closure_at > ( Date.today + 5.days )
            'intime'
          elsif planned_closure_at.between?( Date.today, ( Date.today + 5.days ) )
            'expiring'
          elsif planned_closure_at < Date.today
            'expired'
          end
        else
          'intime'
        end
      end
    return new_status
  end


  def samples_status(samples_count: samples.count)
    if ( samples_count < n_samples.to_i  )
      'warning'
    elsif ( samples_count == n_samples.to_i  )
      'success'
    elsif ( samples_count > n_samples.to_i  )
      'alert'
    end
  end

  private

  def prerequisite
    self.author = 'System' if author.blank? || author.nil?
    self.code = next_code if code.blank? && new_record?
    self.chief = User.chiefs.first if chief.blank?
    self.n_samples = 0 if n_samples.blank?
    self.template = Settings.config.template if template.blank?
    self.consolidated_changed = consolidated_changed?
    self.job_manager_ids.reject!{ |m| m.blank? }
    self.job_technician_ids.reject!{ |t| t.blank? }
    self.status = get_status
  end

  def next_code
    year = Time.new.strftime('%Y')
    year_short = Time.new.strftime('%y')
    rows = Job.unscoped.created_in(year).reorder(:code)
    return rows.blank? ? "#{year_short}#{'1'.rjust(4, '0')}" : "#{rows.last.code.try(:to_i) + 1}"
  end
end