class Log < ApplicationRecord
  belongs_to :loggable, polymorphic: true
  belongs_to :job, :class_name => "Job", :foreign_key => "job_id"

  before_validation :prerequisite
  validates :author, presence: true
  validates :action, presence: true
  validates :body, presence: true

  default_scope { order(created_at: :desc) }
  scope :created_in, ->( year = Date.today.strftime("%Y") ) { where( "extract(YEAR from created_at ) = ?", year ) }

  def update
    false
  end

  def destroy
    false
  end

  def self.years
    return Log.all.select("extract(YEAR from logs.created_at ) as years").group("years").reorder("years desc")
  end

  def created_on
    created_at.present? ? I18n.l( created_at.to_time ) : ''
  end

  def self.historicize( current_user )
    log_file_name = "#{Rails.root}/log/logs_#{Time.now.strftime("%Y%m%d_%H%M%S")}.log"
    unless File.exist?(File.dirname(log_file_name))
      FileUtils.mkdir_p(File.dirname(log_file_name))
    end
    logs = Log.left_outer_joins(:job)
    File.open(log_file_name, "w+") do |f|
      logs.each do | log |
        content = "#{ log.created_at.try(:to_s) };#{ log.job.title unless log.job.blank? };#{ log.action };#{ log.body };#{ log.author }\n"
        f.write(content)
      end
    end
    Log.delete_all
    Log.create(author: current_user.label, action: 'historicizes', loggable_type: 'Log', body: 'Storicizzazione eseguita con successo!')
  end

  private
    def prerequisite
      self.author = 'System' if author.blank?
    end
end
