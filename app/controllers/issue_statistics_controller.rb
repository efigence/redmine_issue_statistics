class IssueStatisticsController < ApplicationController
  unloadable
  before_filter :get_periods, :authenticate
  def index
  	@issue_statistics = IssueStatistic.all
  end
  
  def users_stats
    @issue_statistics = IssueStatistic.where(statisticable_type: 'User')
    render :index
  end

  def projects_stats
    @issue_statistics = IssueStatistic.where(statisticable_type: 'Project')
    render :index
  end

  private
  
  def get_periods
    @periods ||= %w(week month year all)
  end

  def authenticate 
    User.current.admin? || authorize
  end
end
