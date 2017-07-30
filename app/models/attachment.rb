class Attachment < ApplicationRecord
  belongs_to :attachable, optional: true

  validates :file, presence: true

  mount_uploader :file, FileUploader
end
