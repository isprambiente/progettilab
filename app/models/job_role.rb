class JobRole < ApplicationRecord
  belongs_to :job, :class_name => "Job", :foreign_key => "job_id"
  belongs_to :user, :class_name => "User", :foreign_key => "user_id"

  validates_uniqueness_of :user_id, :scope => :job_id, :message => lambda{ |x,y| I18n.t('exist', scope: 'jobs.filter.roles', default: 'Role just exist!', user: x.user.label, list: I18n.t( x.manager? ? 'job_technician_ids' : 'job_manager_ids' , scope: 'jobs.fields', default: 'Users' ) ) }

  attr_accessor :author

  def self.role_removed(job, user, author, role)
    JobMailer.delete(job, user, author: author, role: role).deliver_now
  end

  def self.role_created(job, user, author, role)
    JobMailer.create(job, user, author: author, role: role).deliver_now
  end

end