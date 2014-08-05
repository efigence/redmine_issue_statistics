class RenameColumnCommentsCount < ActiveRecord::Migration
  def up
    rename_column :issue_statistics, :comments_count, :comment_max
  end

  def down
  end
end
