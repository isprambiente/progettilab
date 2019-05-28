class Nuclide < ApplicationRecord
  has_many :logs, as: :loggable
  accepts_nested_attributes_for :logs, :reject_if => :all_blank, :allow_destroy => true

  validates :title, presence: true, uniqueness: true

  attr_accessor :author

  before_validation :prerequisite
  before_save :create_log

  default_scope { order(title: :asc) }

  private

  def prerequisite
  end
end
