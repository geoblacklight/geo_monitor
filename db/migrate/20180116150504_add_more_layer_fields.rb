class AddMoreLayerFields < ActiveRecord::Migration[5.1]
  def change
    add_column :geo_monitor_layers, :rights, :string
    add_column :geo_monitor_layers, :institution, :string
  end
end
