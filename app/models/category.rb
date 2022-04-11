# frozen_string_literal: true

class Category < ApplicationRecord
  before_save :capitalize_name

  validates :name, presence: true

  private

  def capitalize_name
    name.capitalize!
  end
end
