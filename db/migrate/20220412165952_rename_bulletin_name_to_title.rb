class RenameBulletinNameToTitle < ActiveRecord::Migration[6.1]
  def change
    rename_column :bulletins, :name, :title
  end
end
