class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable
  belongs_to :user

  accepts_nested_attributes_for :attachments

  validates :title, :body, presence: true
end
