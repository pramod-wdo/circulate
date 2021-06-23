class AddPositionToHold < ActiveRecord::Migration[6.1]
  def change
    add_column :holds, :position, :integer

    Item.find_each do |item|
      item.holds.order(:created_at).each.with_index(1) do |hold, index|
        hold.update_column :position, index
      end
    end

    change_column_null :holds, :position, false

    add_index :holds, [:item_id, :position], unique: true
  end
end