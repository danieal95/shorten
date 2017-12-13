class CreateLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :logs do |t|
      t.references :short, foreign_key: true
      t.datetime :seen

      t.timestamps
    end
  end
end
