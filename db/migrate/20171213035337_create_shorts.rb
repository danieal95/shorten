class CreateShorts < ActiveRecord::Migration[5.1]
  def change
    create_table :shorts do |t|
      t.string :url
      t.string :shortcode

      t.timestamps
    end
  end
end
