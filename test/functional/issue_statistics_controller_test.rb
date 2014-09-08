require File.expand_path('../../test_helper', __FILE__)

include RedmineIssueStatistics

class IssueStatisticsControllerTest < ActionController::TestCase
  self.fixture_path = File.join(File.dirname(__FILE__), '../fixtures')

  fixtures :issue_statistics,
           :users,
           :groups_users,
           :issues,
           :settings

  include Redmine::I18n

  def setup
    @request.session[:user_id] = 2
  end

  test 'index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:issue_statistics)
    assert_template 'index'
  end

  test 'users_stats' do
    get :index, user_id: 1
    assert_response :success
    assert_template 'index'
  end
  
  test 'projects_stats' do
    get :index, project_id: 1
    assert_response :success
    assert_template 'index'
  end
  
  test 'principal_stats_per_project' do
    get :index, user_id: 1, project_id: 1
    assert_response 200
    assert_template 'index'
  end

  test 'project_total_issues' do
    get :total_issues, statisticable_id: 1, period: 'week'
    assert_redirected_to issues_path({
      :set_filter => 1, 
      "f" => ["project_id", "created_on"], 
      "op[created_on]" => "><", 
      "op[project_id]" => "=",
      "v[created_on]" => ["2014-09-01", "2014-08-13"], 
      "v[project_id][]" => "1"
      })
    assert_response 302
    assert_equal 1, assigns(:results).count, "!"
  end

  test 'project_opened_issues' do
    get :opened_issues, statisticable_id: 1, period: 'week'
    assert_redirected_to issues_path({
      :set_filter => 1, 
      "f" => ["project_id", "status_id", "created_on"], 
      "op[created_on]" => "><",
      "op[project_id]" => "=",
      "op[status_id]" => "o",
      "v[created_on]" => ["2014-09-01", "2014-08-13"], 
      "v[project_id][]" => "1"
      })
    assert_response 302
    assert_equal 1, assigns(:results).count, "This Project should have 1 opened issue!"
  end

  test 'project_closed_issues' do
    get :closed_issues, statisticable_id: 1, period: 'week'
    assert_redirected_to issues_path({
      :set_filter => 1, 
      "f" => ["project_id", "status_id", "created_on"], 
      "op[created_on]" => "><",
      "op[project_id]" => "=",
      "op[status_id]" => "c",
      "v[created_on]" => ["2014-09-01", "2014-08-13"], 
      "v[project_id][]" => "1"
      })
    assert_response 302
    assert_equal 0, assigns(:results).count, "This Project should not have cloased issues!"
  end

  test 'project_returned_issues' do
    get :returned_issues, statisticable_id: 1, period: 'week'
    assert_redirected_to issues_path({
      set_filter: 1,  
      "f[]" => "id", 
      "op[id]" => "=",
      "v[id]" => ["1"]
      })
    assert_response 302
    assert_equal 1, assigns(:results).count, "This Project should have 1 returned issue!"
  end

  test 'project_most_commented_issues' do
    get :most_commented_issues, statisticable_id: 1, period: 'week'
    assert_redirected_to issues_path({
      set_filter: 1,  
      "f[]" => "id", 
      "op[id]" => "=",
      "v[id]" => []
    })
    assert_response 302
    assert_equal 0, assigns(:results).count, "This Project should not have any commented issues > 5"
  end

  test 'project_older_issues' do
    get :older_issues, statisticable_id: 1, period: 'week'
    assert_redirected_to issues_path({
      :set_filter => 1, 
      "f" => ["project_id", "status_id", "created_on"], 
      "op[created_on]" => "<=",
      "op[project_id]" => "=",
      "op[status_id]" => "o",
      "v[created_on]" => ["2014-09-01"], 
      "v[project_id][]" => "1"
      })
    assert_response 302
    assert_equal 0, assigns(:results).count, "This Project should not have older then week issues!"
  end

  test 'principal_total_issues' do
    get :total_issues, statisticable_id: 2, period: 'week'
    assert_redirected_to issues_path({
      :set_filter => 1, 
      "f" => ["assigned_to_id", "created_on"], 
      "op[created_on]" => "><",
      "op[assigned_to_id]" => "=",
      "v[created_on]" => ["2014-09-01", "2014-08-13"], 
      "v[assigned_to_id][]" => "2"
      })
    assert_response 302
    assert_equal 1, assigns(:results).count, "This Principal should have 1 issue!"
  end

  test 'principal_opened_issues' do
    get :opened_issues, statisticable_id: 2, period: 'week'
    assert_redirected_to issues_path({
      :set_filter => 1, 
      "f" => ["assigned_to_id", "status_id", "created_on"], 
      "op[created_on]" => "><",
      "op[assigned_to_id]" => "=",
      "op[status_id]" => "o",
      "v[created_on]" => ["2014-09-01", "2014-08-13"], 
      "v[assigned_to_id][]" => "2"
      })
    assert_response 302
    assert_equal 1, assigns(:results).count, "This Principal should have 1 opened issue!"
  end

  test 'principal_closed_issues' do
    get :closed_issues, statisticable_id: 2, period: 'week'
    assert_redirected_to issues_path({
      :set_filter => 1, 
      "f" => ["assigned_to_id", "status_id", "created_on"], 
      "op[created_on]" => "><",
      "op[assigned_to_id]" => "=",
      "op[status_id]" => "c",
      "v[created_on]" => ["2014-09-01", "2014-08-13"], 
      "v[assigned_to_id][]" => "2"
      })
    assert_response 302
    assert_equal 0, assigns(:results).count, "This Principal should not have closed issues!"
  end

  test 'principal_returned_issues' do
    get :returned_issues, statisticable_id: 2, period: 'week'
    assert_redirected_to issues_path({
      set_filter: 1,  
      "f[]" => "id", 
      "op[id]" => "=",
      "v[id]" => ["1"]
      })
    assert_response 302
    assert_equal 1, assigns(:results).count, "This Principal should have 1 returned issue!"
  end

  test 'principal_most_commented_issues' do
    get :most_commented_issues, statisticable_id: 2, period: 'week'
    assert_redirected_to issues_path({
      set_filter: 1,  
      "f[]" => "id", 
      "op[id]" => "=",
      "v[id]" => []
    })
    assert_response 302
    assert_equal 0, assigns(:results).count, "This Principal should not have commented issue! > 5"
  end

  test 'principal_older_issues' do
    get :older_issues, statisticable_id: 2, period: 'week'
    assert_redirected_to issues_path({
      :set_filter => 1, 
      "f" => ["assigned_to_id", "status_id", "created_on"], 
      "op[created_on]" => "<=",
      "op[assigned_to_id]" => "=",
      "op[status_id]" => "o",
      "v[created_on]" => ["2014-09-01"], 
      "v[assigned_to_id][]" => "2"
      })
    assert_response 302
    assert_equal 0, assigns(:results).count, "This Principal should not have older issue then week!"
  end

  test 'search by user in different group' do
    get :index, user_id: 4
    assert_response :success
    assert_equal true, assigns(:issue_statistics).empty?
  end

  test 'get access to index page without privileges' do
    @request.session[:user_id] = 2
      user = User.find(2)
      user.admin = false
      user.save
    get "index"
    assert_response 403
  end

  test 'project - user redirection' do
    get :total_issues, statisticable_id: 1, statisticable_type: "Project", relate_id: 2, period: 'month'
    assert_redirected_to issues_path({
      :set_filter => 1, 
      "f" => ["project_id", "assigned_to_id", "created_on"], 
      "op[project_id]" => "=",
      "op[created_on]" => "><",
      "op[assigned_to_id]" => "=",
      "v[project_id][]" => "1", 
      "v[created_on]" => ["2014-08-08", "2014-09-01"], 
      "v[assigned_to_id][]" => "2"
      })
    assert_response 302
    assert_equal 1, assigns(:results).count, "This Principal should have 1 opened issue!"
  end
end