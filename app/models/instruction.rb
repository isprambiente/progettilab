class Instruction < ApplicationRecord
	has_many :logs, as: :loggable
  accepts_nested_attributes_for :logs, :reject_if => :all_blank, :allow_destroy => true

  has_many :analisy_types, :class_name => 'AnalisyType'

  has_attached_file :file, :url => '/files/:job_code/istructions/:filename', :path => ':rails_root/private:url'
  do_not_validate_attachment_file_type :file
  validates_attachment_size :file, :less_than => 5.megabytes, :message => I18n.t("less_than", scope: ['attachment', 'errors'], default: "less_than 20 megabytes")

  validates :title, presence: true, uniqueness: true

  attr_accessor :author

  before_validation :prerequisite
  before_save :create_log

  default_scope { order(title: :asc) }

  def delete
    destroy
  end

  def destroy
    analisy_types.present? ? update( active: false ) : super
  end

  private

  def prerequisite
  end
end
