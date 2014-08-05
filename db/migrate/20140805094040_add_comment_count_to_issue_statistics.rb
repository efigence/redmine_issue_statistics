class AddCommentCountToIssueStatistics < ActiveRecord::Migration
  def change
    add_column :issue_statistics, :comments_count, :integer
  end
end
