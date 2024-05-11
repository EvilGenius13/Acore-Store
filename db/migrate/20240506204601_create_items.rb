class CreateItems < ActiveRecord::Migration[7.1]
  def change
    create_table :items do |t|
      t.string :name
      t.string :mainclass
      t.string :subclass
      t.float :price
      t.boolean :for_sale
      t.integer :amount_purchased

      t.timestamps
    end
  end
end
