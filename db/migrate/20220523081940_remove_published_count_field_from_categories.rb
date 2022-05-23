class RemovePublishedCountFieldFromCategories < ActiveRecord::Migration[6.1]
  def change
    remove_column :categories, :published_count, :integer
  end
end
