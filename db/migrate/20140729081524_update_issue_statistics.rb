class UpdateIssueStatistics < ActiveRecord::Migration
  def up
    rename_column :issue_statistics, :object_id, :statisticable_id
    rename_column :issue_statistics, :object_type, :statisticable_type
  end

  def down
  end
end
