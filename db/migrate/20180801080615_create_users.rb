class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name,
      t.string :email,
      t.boolean :admin, default: false
      t.string :avatar
      t.timestamps
    end
  end
  add_index :users, :email, unique: true
end