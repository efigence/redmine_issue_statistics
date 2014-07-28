class CreateIssueStatistics < ActiveRecord::Migration
  def change
    create_table :issue_statistics do |t|
     t.integer "object_id", :null => false #user_id/project
     t.integer "object_type", :null => false #project/user
     t.integer "total" #all belongs to user/project
     t.integer "opened" 
     t.integer "closed" 
     t.float "opened_to_closed"  #ratio open to close %
     t.integer "returned" # returned to user/project(status- bug,feedback,rejected etc)
     t.integer "from_close_to"  #closed but not finished
     t.integer "avg_issue_time" 
     #t.integer "max comment"
     #last active
    end
  end
end
