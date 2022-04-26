class AddStateToBulletins < ActiveRecord::Migration[6.1]
  def change
    add_column :bulletins, :state, :string, null: false, default: 'draft'
  end
end
