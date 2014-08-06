class AddColumnsToIssueStatistics < ActiveRecord::Migration
  def change
    add_column :issue_statistics, :relate_id, :integer
    add_column :issue_statistics, :relate_type, :string
  end
end
