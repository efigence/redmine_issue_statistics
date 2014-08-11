class IssueStatisticsController < ApplicationController
  unloadable
  before_filter :get_periods, :authenticate
  def index
  	@issue_statistics = IssueStatistic.where(relate_type: nil).paginate(:page => params[:page])
    render :index
  end
  
  def users_stats
    @issue_statistics = IssueStatistic.where(statisticable_type: 'User', relate_type: nil).paginate(:page => params[:page])
    render :index
  end

  def projects_stats
    @issue_statistics = IssueStatistic.where(statisticable_type: 'Project', relate_type: nil).paginate(:page => params[:page])
    render :index
  end

  def principal_stats_per_project
    @issue_statistics = IssueStatistic.where(relate_type: "User").order('statisticable_id, statisticable_type, relate_id').paginate(:page => params[:page])
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
