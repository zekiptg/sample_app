class Micropost < ApplicationRecord
  belongs_to :user, dependent: :destroy
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.valid.length.contentMicropost.maximum}
  validate  :picture_size
  scope :sort_micro, ->{order created_at: :desc}

  private
  def size_notify
    errortext = t "notify.error.micropost.picture"
    errors.add(:picture, errortext)
  end

  def picture_size
    size_notify if picture.size > Settings.image.size.maximum.megabytes
  end
end
