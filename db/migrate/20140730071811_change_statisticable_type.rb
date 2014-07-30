class ChangeStatisticableType < ActiveRecord::Migration
  def up
   change_column :issue_statistics, :statisticable_type, :string
  end

  def down
   change_column :issue_statistics, :statisticable_type, :integer
  end
end
