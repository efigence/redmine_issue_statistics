class IssueStatistic < ActiveRecord::Base
  unloadable
  before_save :recalculate_returned_ratio
  attr_accessible  :object_id, :object_type, :total, :opened, :closed, :opened_to_closed,
    :returned, :from_close_to, :total_assigned, :comment_max, :returned_ratio,
    :old_issues, :resolved

  belongs_to :statisticable, :polymorphic => true


  def recalculate_returned_ratio
    if self.returned != 0 && self.returned != nil && self.total.blank? && !self.total_assigned.blank? && self.total_assigned != 0
      self.returned_ratio = (self.returned/self.total_assigned.to_f) * 100
    elsif self.returned != 0 && self.returned != nil && !self.total.blank?
      self.returned_ratio = (self.returned/self.total.to_f) * 100
    else
      self.returned_ratio = 0
    end
  end
end
