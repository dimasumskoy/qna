class Attachment < ApplicationRecord
  belongs_to :attachable, optional: true

  mount_uploader :file, FileUploader
end
