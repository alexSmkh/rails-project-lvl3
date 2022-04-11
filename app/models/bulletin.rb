# frozen_string_literal: true

class Bulletin < ApplicationRecord
  has_one_attached :image

  before_save :capitalize_name

  belongs_to :user
  belongs_to :category

  validates :name, presence: true, length: { maximum: 100 }
  validates :description, presence: true, length: { maximum: 3000 }

  validates :image, attached: true,
                    content_type: ['image/png', 'image/jpg', 'image/jpeg'],
                    size: { less_than: 5.megabytes }

  private

  def capitalize_name
    name.capitalize!
  end
end
