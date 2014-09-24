class AddResolvedToIssueStatistics < ActiveRecord::Migration
	def change
		add_column :issue_statistics, :resolved, :integer
	end
end
