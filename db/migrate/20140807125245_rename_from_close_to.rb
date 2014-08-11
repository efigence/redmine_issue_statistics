class RenameFromCloseTo < ActiveRecord::Migration
  def up
    rename_column :issue_statistics, :from_close_to, :returned_ratio
  end

  def down
  end
end
