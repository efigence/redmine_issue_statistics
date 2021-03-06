class IssueStatisticsController < ApplicationController
  unloadable

  skip_before_filter :check_if_login_required, if: :api_request?
  before_filter :permitted_to_api?, if: :api_request?
  before_filter :user_privileges
  before_filter :find_statisticable, :only => [:total_issues, :opened_issues, :closed_issues, :older_issues]
  before_filter :scope_my_groups_data, :only => [:index]
  before_filter :get_periods
  before_filter :set_period, :only => [:opened_from_journal, :total_logged_issues, :resolved_issues, :total_issues, :opened_issues, :returned_issues, :most_commented_issues, :closed_issues, :older_issues]

  include RedmineIssueStatistics

  def is_admin?
    User.current.admin?
  end

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
        render :json => {
          :current_page => @issue_statistics.current_page,
          :per_page => @issue_statistics.per_page/4,
          :total_pages => @issue_statistics.total_pages,
          :entries => @issue_statistics
        }
      end
    end
  end

  def avalible_data
    if is_admin?
      @issue_statistics = IssueStatistic.where("")
    else
      @issue_statistics = IssueStatistic.
      where('(statisticable_id IN(?) AND statisticable_type = ? )
                                          OR (statisticable_id IN(?) AND statisticable_type = ? AND relate_id IS NULL)
                                          OR statisticable_id IN(?) AND statisticable_type = ? AND relate_id IN(?)',
            @users_tab, 'User',
            @projects_tab, 'Project',
            @projects_tab, 'Project', @users_tab)
    end
  end

  def all
    @issue_statistics = avalible_data.order('relate_id, id').paginate(:page => params[:page], :per_page => per_page)
  end

  def users_stats
    @issue_statistics = avalible_data.where(statisticable_type: 'User', relate_type: nil, statisticable_id: params[:user_id]).
      paginate(:page => params[:page], :per_page => per_page)
  end

  def projects_stats
    @issue_statistics = avalible_data.where(statisticable_type: 'Project', relate_type: nil, statisticable_id: params[:project_id]).
      paginate(:page => params[:page], :per_page => per_page)
  end

  def principal_stats_per_project
    @issue_statistics = avalible_data.
      where(relate_type: "User", relate_id: params[:user_id]).
      where(statisticable_type: 'Project', statisticable_id: params[:project_id]).
      order('statisticable_id, statisticable_type, relate_id').
      paginate(:page => params[:page], :per_page => per_page)
  end

  def total_issues
    @results = base
    @specified_total_params = {
      "f" => ["created_on"],
      "op[created_on]" => "><",
      "v[created_on]" => [@periods_datetime.to_date, @r.created_at.to_date.strftime("%Y-%m-%d").to_date]
    }
    set_path @r, @periods_datetime, @specified_total_params
  end

  def opened_issues
    @results = base.open
    @specified_open_params = {
      "f" => ["status_id", "created_on"],
      "op[status_id]" => "o",
      "op[created_on]" => "><",
      "v[created_on]" => [@periods_datetime.to_date, @r.created_at.to_date.strftime("%Y-%m-%d").to_date]
    }
    set_path @r, @periods_datetime, @specified_open_params
  end

  def closed_issues
    @results = []
    base.each do |res|
      if res.closed?
        @results << res
      end
    end
    @specified_closed_params = {
      "f" => ["status_id", "created_on"],
      "op[status_id]" => "c",
      "op[created_on]" => "><",
      "v[created_on]" => [@periods_datetime.to_date, @r.created_at.to_date.strftime("%Y-%m-%d").to_date]
    }
    set_path @r, @periods_datetime, @specified_closed_params
  end

  def returned_issues
    if params[:statisticable_type] == "Project" && !params[:relate_id]
      @results = []
      Queries.returned_query(base).each do |res|
        @results << Issue.find(res.journalized_id)
      end
      redirect_to_path @results
    elsif !!params[:relate_id]
      @results = Queries.returned_for_users(Principal.find(params[:relate_id]), @periods_datetime, params[:statisticable_id])
      redirect_to_total_logged_path @results
    elsif !params[:relate_id] && params[:statisticable_type] != "Project"
      @results = Queries.returned_for_users(Principal.find(params[:statisticable_id]), @periods_datetime)
      redirect_to_total_logged_path @results
    end

  end

  def most_commented_issues
    @results = []
    base.each do |issue|
      comments = Queries.comment_query(issue.id, @periods_datetime).count
      @results << Issue.find(issue.id) if comments > Setting.plugin_redmine_issue_statistics['comment_settings'].to_i
    end
    redirect_to_path @results
  end

  def older_issues
    if !!params[:relate_id]
      @results = Queries.old_issues_query(Principal.find(params[:relate_id]), @periods_datetime)
    else
      @results = Queries.old_issues_query(IssueStatistic.where(statisticable_id: params[:statisticable_id]).first.statisticable, @periods_datetime)
    end
    @specified_older_issues_params = {
      "f" => ["status_id", "created_on"],
      "op[status_id]" => "o",
      "op[created_on]" => "<=",
      "v[created_on][]" => @periods_datetime.to_date
    }
    set_path @r, @periods_datetime, @specified_older_issues_params
  end

  def resolved_issues
    if !!params[:relate_id]
      @results = Queries.resolved_user_per_project(Principal.find(params[:relate_id]), @periods_datetime, base, params[:statisticable_id] )
    else
      @results = Queries.resolved_query(Principal.find(params[:statisticable_id]), @periods_datetime)
    end
    @results.each{|j| j.id = j.journalized_id }
    redirect_to_path @results
  end

  def total_logged_issues
    if !!params[:relate_id]
      @results = Queries.total_logged_to(Principal.find(params[:relate_id]), @periods_datetime, params[:statisticable_id])
    else
      @results = Queries.total_logged_to(Principal.find(params[:statisticable_id]), @periods_datetime)
    end
    redirect_to_total_logged_path @results
  end

  def opened_from_journal
    if !!params[:relate_id]
      @results = Queries.opened_by_journal_query(Principal.find(params[:relate_id]), @periods_datetime, params[:statisticable_id])
    else
      @results = Queries.opened_by_journal_query(Principal.find(params[:statisticable_id]), @periods_datetime)
    end
    redirect_to_total_logged_path @results
  end


  private

  def find_statisticable
    @r = IssueStatistic.where(statisticable_id: params[:statisticable_id], statisticable_type: params[:statisticable_type], relate_id: params[:relate_id]).first
  end

  def base
    if !!params[:relate_id]
      query = Queries.base_query(Principal.find(params[:relate_id]) , @periods_datetime)
      query = Queries.project_scope( query, params[:statisticable_id] )
    else
      query = Queries.base_query(IssueStatistic.where(statisticable_id: params[:statisticable_id], statisticable_type: params[:statisticable_type]).first.statisticable, @periods_datetime)
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

  def per_page
    @per_page ||= Setting.plugin_redmine_issue_statistics['per_page'].to_i * 4
  end

  def user_privileges
    deny_access unless is_admin? || has_access?
  end

  def permitted_to_api?
    User.current = User.find_by_api_key(request.headers['Authorization']) || User.find_by_api_key(params[:key])
  end

  def has_access?
    !(user_ids & groups_with_access).blank?
  end

  def user_ids
    User.current.groups.select('id').collect{|el| el.id.to_s}
  end

  def groups_with_access
    Setting.plugin_redmine_issue_statistics[:groups] || []
  end

  def scope_my_groups_data
    unless is_admin?
      users_tab, projects_tab = [], []
      User.current.groups.each do |group|
        group.users.each do |user|
          users_tab << user.id
          user.projects.each do |project|
            projects_tab << project.id
          end
        end
      end
      @users_tab = users_tab.uniq.sort
      @projects_tab = projects_tab.uniq.sort
    end
  end
end
