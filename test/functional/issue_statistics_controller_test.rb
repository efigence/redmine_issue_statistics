require File.expand_path('../../test_helper', __FILE__)

include RedmineIssueStatistics

class IssueStatisticsControllerTest < ActionController::TestCase
  self.fixture_path = File.join(File.dirname(__FILE__), '../fixtures')

  fixtures :issue_statistics,
           :users

  include Redmine::I18n

  def setup
    @request.session[:user_id] = 2
  end

  test 'index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:issue_statistics)
    assert_template 'index'
    assert_select 'a[href="/issue_statistics/index"]'
    assert_select 'a[href="/issue_statistics/users_stats"]'
    assert_select 'a[href="/issue_statistics/projects_stats"]'
    assert_select 'a[href="/issue_statistics/principal_stats_per_project"]'
  end

  test 'users_stats' do
    get :users_stats
    assert_response :success
    assert_template 'index'
  end
  
  test 'projects_stats' do
    get :projects_stats
    assert_response :success
    assert_template 'index'
  end
  
  test 'principal_stats_per_project' do
    get :principal_stats_per_project
    assert_response :success
    assert_template 'index'
  end

  test 'project_total_issues' do
    get :total_issues, statisticable_id: 1, period: 'week'
    assert_response :success
    assert_template 'results'
  end

  test 'project_opened_issues' do
    get :opened_issues, statisticable_id: 1, period: 'week'
    assert_response :success
    assert_template 'results'
  end

  test 'project_closed_issues' do
    get :closed_issues, statisticable_id: 1, period: 'week'
    assert_response :success
    assert_template 'results' 
  end

  test 'project_returned_issues' do
    get :returned_issues, statisticable_id: 1, period: 'week'
    assert_response :success
    assert_template 'results'
  end

  test 'project_most_commented_issues' do
    get :most_commented_issues, statisticable_id: 1, period: 'week'
    assert_response :success
    assert_template 'results'
  end

  test 'project_older_issues' do
    get :older_issues, statisticable_id: 1, period: 'week'
    assert_response :success
    assert_template 'results'
  end

  test 'principal_total_issues' do
    get :total_issues, statisticable_id: 2, period: 'week'
    assert_response :success
    assert_template 'results'
  end

  test 'principal_opened_issues' do
    get :opened_issues, statisticable_id: 2, period: 'week'
    assert_response :success
    assert_template 'results'
  end

  test 'principal_closed_issues' do
    get :closed_issues, statisticable_id: 2, period: 'week'
    assert_response :success
    assert_template 'results' 
  end

  test 'principal_returned_issues' do
    get :returned_issues, statisticable_id: 2, period: 'week'
    assert_response :success
    assert_template 'results'
  end

  test 'principal_most_commented_issues' do
    get :most_commented_issues, statisticable_id: 2, period: 'week'
    assert_response :success
    assert_template 'results'
  end

  test 'principal_older_issues' do
    get :older_issues, statisticable_id: 2, period: 'week'
    assert_response :success
    assert_template 'results'
  end
end