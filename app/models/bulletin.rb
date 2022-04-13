# frozen_string_literal: true

class Bulletin < ApplicationRecord
  has_one_attached :image

  before_save :capitalize_title

  belongs_to :user
  belongs_to :category

  validates :title, presence: true, length: { maximum: 100 }
  validates :description, presence: true, length: { maximum: 3000 }

  validates :image, attached: true,
                    content_type: ['image/png', 'image/jpg', 'image/jpeg'],
                    size: { less_than: 5.megabytes }

  private

  def capitalize_title
    title.capitalize!
  end
end
