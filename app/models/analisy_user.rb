class AnalisyUser < ApplicationRecord
  belongs_to :analisy, :class_name => "Analisy", :foreign_key => "analisy_id"
  belongs_to :user, :class_name => "User", :foreign_key => "user_id"
  has_one  :job, :through => :analisy, source: :job


  enum role: { chief: 0, headtest: 1, technic: 2 }

  attr_accessor :author

  validates :user_id, presence: true
  validates :role, presence: true

  has_many :logs, as: :loggable
  accepts_nested_attributes_for :logs, :reject_if => :all_blank, :allow_destroy => true
end
