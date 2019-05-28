class CreateNuclides < ActiveRecord::Migration[5.2]
  def change
    enable_extension 'citext'

    create_table :nuclides do |t|
      t.citext  :title,    index: true, null: false, default: '', unique: true
      t.text    :body

      t.boolean :active,     index: true, null: false, default: true

      t.timestamps
    end
  end
end
