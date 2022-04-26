class AddPublishedCountToCategories < ActiveRecord::Migration[6.1]
  def self.up
    add_column :categories, :published_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :categories, :published_count
  end
end
