class AddColumnToReport < ActiveRecord::Migration[6.1]
  def change
    add_column :reports, :x_axis, :string
    add_column :reports, :y_axis, :string
  end
end
