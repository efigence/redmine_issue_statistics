class AddPeriodToIssueStatistic < ActiveRecord::Migration
  def change
    add_column :issue_statistics, :period, :string
  end
end
