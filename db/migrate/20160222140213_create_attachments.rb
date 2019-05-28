class CreateAttachments < ActiveRecord::Migration[5.2]
  def change
    enable_extension 'citext'

    create_table :attachments do |t|
      t.references  :attachable,  :polymorphic => true, index: true
      t.citext      :title,                             index: true, default: '', null: false
      t.text        :body,                              index: true, default: ''
      t.integer     :category,                          index: true, default: 0, null: false
      t.attachment  :file

      t.timestamps null: false
    end
  end
end
