class CreateUser < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :password_digest, null: false
      t.string :e_mail, null: false

      t.timestamps
    end
  end
end
