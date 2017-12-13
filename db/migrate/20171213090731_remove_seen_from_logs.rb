class RemoveSeenFromLogs < ActiveRecord::Migration[5.1]
  def change
    remove_column :logs, :seen, :datetime
  end
end
