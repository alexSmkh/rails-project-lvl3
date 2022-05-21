class RemoveBulletinsCountFromCategory < ActiveRecord::Migration[6.1]
  def change
    remove_column :categories, :bulletins_count, :integer
  end
end
