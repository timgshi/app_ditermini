class AddLatToPhoto < ActiveRecord::Migration
  def change
    add_column :photos, :lat, :float
  end
end
