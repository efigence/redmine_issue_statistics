require File.expand_path('../../test_helper', __FILE__)

include RedmineIssueStatistics

class IssueStatisticConfigurationTest < ActiveSupport::TestCase
  self.fixture_path = File.join(File.dirname(__FILE__), '../fixtures')

  fixtures :issues,
           :journals, 
           :journal_details,  
           :users,
           :projects,
           :time_entries,
           :members,
           :settings

  def setup
    IssueStatistic.destroy_all
  end

  test 'basic and returned issues configuration' do
    Setting.last.destroy
    set = Setting.new
    set.name = "plugin_redmine_issue_statistics"
    set.value = {"comment_settings"=>"7", "returned"=>"4", 
                 "returned_table_to" => ["1", "2", "4", "8"],
                 "returned_table_from" => ["3", "5", "7", "9", "10", "11", "12"]}
    set.save  
    set.reload
    RedmineIssueStatistics::CalculateStatistic.new.calculate
    stat_project = IssueStatistic.where(statisticable_type: "project").first
    assert_equal 0, stat_project.returned, 'Wrong returned count'
    assert_equal 0, stat_project.comment_max, 'Wrong comment count'
  end
end