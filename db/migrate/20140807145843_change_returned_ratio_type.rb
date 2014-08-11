class ChangeReturnedRatioType < ActiveRecord::Migration
  def up
    change_column :issue_statistics, :returned_ratio, :float
  end

  def down
    change_column :issue_statistics, :returned_ratio, :integer
  end
end
