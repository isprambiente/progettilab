class MatrixType < ApplicationRecord
  has_many :samples, :class_name => "Sample", :foreign_key => "type_matrix_id"
  has_many :logs, as: :loggable
  accepts_nested_attributes_for :logs, :reject_if => :all_blank, :allow_destroy => true

  validates :title, presence: true, uniqueness: [:pid, :title]

  attr_accessor :author

  before_validation :prerequisite
  before_save :create_log

  default_scope { order(title: :asc) }
  scope :categories, ->{ where('matrix_types.pid is null') }
  scope :matrices, ->{ where('not matrix_types.pid is null') }

  def self.categories
    MatrixType.unscoped.where( "matrix_types.pid is null" ).order(title: :asc).distinct
  end

  def category
    MatrixType.categories.find(pid)
  end

  private

  def prerequisite
    self.author = 'System' if author.blank?
  end
end
