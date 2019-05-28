class Attachment < ApplicationRecord
  belongs_to :attachable, polymorphic: true
  has_attached_file :file, :path => ':rails_root/private/files/:job_code/:category/:filename'
  before_validation :prerequisite #, on: :create
  do_not_validate_attachment_file_type :file
  validates_attachment :file, size: { :less_than => 20.megabytes, :message => I18n.t("less_than", scope: 'errors.attachment', default: "less than 20 megabytes") }
  # validates_attachment_content_type :file

  attr_accessor :author, :job_code, :version

  enum category: { attachment: 0, documentation: 1, manual: 2, form: 3, image: 4 }

  def self.category_collection
    categories.map{|v,k| [I18n.t(v, scope: "attachments.categories", default: v), v]}.sort
  end


  def get_category
    I18n.t(category.to_s, scope: "attachment.category", default: category.to_s)
  end

  private

  def prerequisite
    self.category = 'attachment' if category.blank?
    self.title = File.basename(file_file_name, File.extname(file_file_name)).gsub('_', ' ') if file_file_name.present? && title.blank?
    if file.blank?
      errors.add(:file, I18n.t( 'blank', scope: 'errors', default: 'not be blank!' ).html_safe )
      return false
    end
  end

  Paperclip.interpolates :job_code  do |attachment, style|
    if attachment.instance.present? && ( defined? attachment.instance.attachable )
      attachment.instance.attachable.code
    end
  end

  Paperclip.interpolates :version  do |attachment, style|
    attachment.instance.version
  end

  Paperclip.interpolates :class  do |attachment, style|
    attachment.instance.class
  end

  Paperclip.interpolates :title  do |attachment, style|
    attachment.instance.title.parameterize
  end

  Paperclip.interpolates :category  do |attachment, style|
    attachment.instance.get_category.parameterize
  end
end
