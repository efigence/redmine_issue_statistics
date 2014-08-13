class IssueStatisticsController < ApplicationController
  unloadable

  before_filter :get_periods, :authenticate
  before_filter :set_period, :only => [:total_issues, :opened_issues, :returned_issues, :most_commented_issues, :closed_issues, :older_issues]

  include RedmineIssueStatistics
 
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

  def total_issues
    @results = base
    render :results
  end

  def opened_issues
    @results = base.open
    render :results
  end

  def closed_issues
    @results = []
    base.each do |res|
      if res.closed?
        @results << res
      end
    end
    render :results
  end

  def returned_issues
    @results = []
    Queries.returned_query(base).each do |res|
      @results << Issue.find(res.journalized_id)
    end
    render :results
  end

  def most_commented_issues
    @results = []
    base.each do |issue|    
      comments = Queries.comment_query(issue.id, @periods_datetime).count
      @results << Issue.find(issue.id) if comments > 5
    end
    render :results
  end

  def older_issues
    if !!params[:relate_id]
      @results = Queries.old_issues_query(Principal.find(params[:relate_id]), @periods_datetime)
    else
      @results = Queries.old_issues_query(IssueStatistic.where(statisticable_id: params[:statisticable_id]).first.statisticable, @periods_datetime)
    end
    render :results
  end

  private

  def base
    if !!params[:relate_id]
      query = Queries.base_query( Principal.find(params[:relate_id]) , @periods_datetime)
      query = Queries.project_scope( query, params[:statisticable_id] )
    else
      query = Queries.base_query(IssueStatistic.where(statisticable_id: params[:statisticable_id]).first.statisticable, @periods_datetime)  
    end
    query
  end

  def set_period
    @period = params[:period]
      period = nil
      case @period
      when 'week'
        period = 1.week.ago
      when 'month'
        period = 1.month.ago
      when 'year'
        period = 1.year.ago
      when 'all'
        period = 1000.years.ago
      end
    @periods_datetime = period
  end

  def get_periods
    @periods ||= %w(week month year all)
  end

  def authenticate 
    User.current.admin? || authorize
  end
end
