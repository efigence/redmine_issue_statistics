class AddOldIssuesToIssueStatistics < ActiveRecord::Migration
  def change
    add_column :issue_statistics, :old_issues, :integer
  end
end
