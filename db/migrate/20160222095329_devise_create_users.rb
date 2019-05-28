class DeviseCreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :username,              null: false, default: ""

      t.string    :label, index: true, default: ''
      t.string    :email, index: true, default: ''
      t.string    :sex,   index: true, default: ''
      # t.jsonb     :metadata, :null => false, :default => '{}'
      t.boolean   :supervisor, index: true, default: false # Referente qualità
      t.boolean   :admin, index: true, default: false # Responsabile area

      ## other roles
      t.boolean :technic, index: true, default: false
      t.boolean :headtest, index: true, default: false
      t.boolean :chief, index: true, default: false
      t.boolean :external, index: true, default: false

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet     :current_sign_in_ip
      t.inet     :last_sign_in_ip

      t.datetime :locked_at

      t.timestamps null: false
    end

    add_index :users, :username,             unique: true
  end
end
