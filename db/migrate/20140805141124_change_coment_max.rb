class ChangeComentMax < ActiveRecord::Migration
  def up
    change_column :issue_statistics, :comment_max, :integer, :default => 0
  end

  def down
    change_column :issue_statistics, :comment_max, :integer
  end
end
