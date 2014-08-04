class AddTimeStampToIssueStatistic < ActiveRecord::Migration
  def self.up
    change_table :issue_statistics do |t|
       t.timestamps
    end  
  end
  def self.down
    
  end
end
