class ChangeColumnNameIssueStatistics < ActiveRecord::Migration
	def up
		rename_column :issue_statistics, :avg_issue_time, :total_assigned
		change_column :issue_statistics, :total_assigned, :integer
	end

	def down
	end
end
