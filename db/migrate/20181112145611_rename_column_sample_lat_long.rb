class RenameColumnSampleLatLong < ActiveRecord::Migration[5.2]
  def change
    rename_column :samples, :lat, :latitude
    rename_column :samples, :long, :longitude
  end
end
