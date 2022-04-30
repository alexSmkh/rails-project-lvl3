# frozen_string_literal: true

class Bulletin < ApplicationRecord
  include AASM

  has_one_attached :image, dependent: :destroy

  scope :published,
        -> { where 'bulletins.state = ?', 'published' }

  belongs_to :user
  belongs_to :category, counter_cache: true
  counter_culture :category,
                  column_name: ->(_model) { :published_count },
                  column_names: {
                    Bulletin.published => :published_count
                  }

  validates :title, presence: true, length: { maximum: 100 }
  validates :description, presence: true, length: { maximum: 3000 }

  validates :image,
            attached: true,
            content_type: %w[image/png image/jpg image/jpeg],
            size: {
              less_than: 5.megabytes
            }

  aasm column: :state, whiny_transitions: false do
    state :draft, initial: true
    state :under_moderation
    state :published
    state :rejected
    state :archived

    event :moderate do
      transitions from: :draft, to: :under_moderation
      transitions from: :rejected, to: :under_moderation
    end

    event :publish do
      transitions from: :under_moderation, to: :published
    end

    event :reject do
      transitions from: :under_moderation, to: :rejected
    end

    event :archive do
      transitions from: :draft, to: :archived
      transitions from: :under_moderation, to: :archived
      transitions from: :rejected, to: :archived
      transitions from: :published, to: :archived
    end
  end
end
