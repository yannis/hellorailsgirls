class CreateRailsGirls < ActiveRecord::Migration[5.1]
  def change
    create_table :rails_girls do |t|
      t.string :name
      t.text :message

      t.timestamps
    end
  end
end
