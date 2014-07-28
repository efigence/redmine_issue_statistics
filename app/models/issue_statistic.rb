class IssueStatistic < ActiveRecord::Base
  unloadable

  attr_accessible  :object_id, :object_type, :total, :opened, :closed, :opened_to_closed,
                   :returned, :from_close_to, :avg_issue_time

end
