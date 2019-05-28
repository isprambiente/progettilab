class AddIndexSampleLatLong < ActiveRecord::Migration[5.2]
  add_index :samples, [:latitude, :longitude]
end
