class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :username
      t.datetime :last_logged_in
      t.datetime :last_logged_in_game

      t.timestamps
    end
  end
end
