class ChangeAvgIssueTimeType < ActiveRecord::Migration
  def up
    change_column :issue_statistics, :avg_issue_time, :float
  end

  def down
    change_column :issue_statistics, :avg_issue_time, :integer
  end
end
