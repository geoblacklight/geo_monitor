class CreateGeoMonitorLayers < ActiveRecord::Migration[5.1]
  def change
    create_table :geo_monitor_layers do |t|
      t.string :slug, index: true, unique: true
      t.string :checktype, index: true
      t.string :layername
      t.string :access, index: true
      t.string :bbox
      t.string :url
      t.integer :statuses_count
      t.boolean :active, index: true
      t.timestamps
    end
  end
end
