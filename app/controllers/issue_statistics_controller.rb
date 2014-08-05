class IssueStatisticsController < ApplicationController
  unloadable
 # before_filter :authorize, :only => :index

  def index
  	@issue_statistics = IssueStatistic.all
    @periods ||= %w(week month year all)
  end

end
