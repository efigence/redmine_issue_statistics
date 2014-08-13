class IssueStatistic < ActiveRecord::Base
  unloadable
  before_save :recalculate_returned_ratio
  attr_accessible  :object_id, :object_type, :total, :opened, :closed, :opened_to_closed,
                   :returned, :from_close_to, :avg_issue_time, :comment_max, :returned_ratio,
                   :old_issues
  
  belongs_to :statisticable, :polymorphic => true

  self.per_page = 4

  def recalculate_returned_ratio
    if self.returned != 0 && self.returned != nil
      self.returned_ratio = (self.returned/self.total.to_f) * 100
    else 
      self.returned_ratio = 0
    end
  end
end
