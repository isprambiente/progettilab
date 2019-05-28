class CreateAnalisyTypes < ActiveRecord::Migration[5.2]
  def change
    enable_extension 'citext'

    create_table :analisy_types do |t|
      t.references  :instruction,                         index: true
      t.citext      :title,                                            null: false
      t.text        :body
      t.boolean     :radon,                               index: true, null: false, default: false
      t.boolean     :active,                              index: true, null: false, default: true

      t.timestamps null: false
    end
    add_index :analisy_types, [:title], unique: true, order: {title: :asc}
  end
end
