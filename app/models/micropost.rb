class Micropost < ApplicationRecord
  belongs_to :user, dependent: :destroy
  has_many :comments
  default_scope ->{order(created_at: :desc)}
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.valid.length.contentMicropost.maximum}
  validate  :picture_size

  private
  def size_notify
    errortext = t "notify.error.micropost.picture"
    errors.add(:picture, errortext)
  end

  def picture_size
    size_notify if picture.size > Settings.image.size.maximum.megabytes
  end
end
