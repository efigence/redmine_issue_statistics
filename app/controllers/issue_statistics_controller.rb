class IssueStatisticsController < ApplicationController
  unloadable

  before_filter :get_periods, :authenticate
  before_filter :set_period, :only => [:total_issues, :opened_issues, :returned_issues, :most_commented_issues, :closed_issues, :older_issues]

  include RedmineIssueStatistics
 
  def index
    if !params[:user_id].blank? && !params[:project_id].blank?
      principal_stats_per_project()
    elsif !params[:user_id].blank?
      users_stats()
    elsif !params[:project_id].blank?
      projects_stats()
    else
      all()
    end

    respond_to do |format|
      format.html do
        render :index
      end
      format.json do 
        render :json => @issue_statistics.to_json
      end
    end
  end

  def all    
  	@issue_statistics = IssueStatistic.
                                    where(relate_type: nil).
                                    paginate(:page => params[:page], :per_page => per_page )
  end
  
  def users_stats
    @issue_statistics = IssueStatistic.
                                    where(statisticable_type: 'User', relate_type: nil, statisticable_id: params[:user_id]).
                                    paginate(:page => params[:page], :per_page => per_page)
  end

  def projects_stats
    @issue_statistics = IssueStatistic.
                                    where(statisticable_type: 'Project', relate_type: nil, statisticable_id: params[:project_id]).
                                    paginate(:page => params[:page], :per_page => per_page)
  end

  def principal_stats_per_project
    @issue_statistics = IssueStatistic.
      where(relate_type: "User", relate_id: params[:user_id]).
      where(statisticable_type: 'Project', statisticable_id: params[:project_id]).
      order('statisticable_id, statisticable_type, relate_id').
      paginate(:page => params[:page], :per_page => per_page)
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
      @results << Issue.find(issue.id) if comments > Setting.plugin_redmine_issue_statistics['comment_settings'].to_i
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

  # def restrict_access 
  #   authenticate_or_request_with_http_token do |token, options|
  #     Token.find_by(value: token)
  #   end
  # end

  def per_page
    @per_page ||= Setting.plugin_redmine_issue_statistics['per_page'].to_i * 4
  end

end
# self.per_page =  Setting.plugin_redmine_issue_statistics['per_page'].to_i