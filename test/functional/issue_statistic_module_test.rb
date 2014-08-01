require File.expand_path('../../test_helper', __FILE__)

include RedmineIssueStatistics

class IssueStatisticTest < ActiveSupport::TestCase
  self.fixture_path = File.join(File.dirname(__FILE__), '../fixtures')

  fixtures :issues,
           :journals, 
           :journal_details,  
           :users,
           :projects,
           :time_entries


  test 'initial_test_fixtures' do
    assert_equal 1, User.count, 'should be 1'
    assert_equal 5, Journal.count, 'should be 5'
    assert_equal 6, JournalDetail.count, 'should be 6'
    assert_equal 0, IssueStatistic.count, 'should be 0'
    assert_equal 1, Project.count, 'should be 1'
  end

  test 'statistic_table_should_be_increment_by_two' do
    assert_difference 'IssueStatistic.count', +2 do
      RedmineIssueStatistics::CalculateStatistic.new.calculate 
    end
  end

  test 'base_calculation_on_new_and_on_update' do
    assert_difference 'IssueStatistic.count', +2 do
      RedmineIssueStatistics::CalculateStatistic.new.calculate
      stat_1 = IssueStatistic.last
      RedmineIssueStatistics::CalculateStatistic.new.calculate
      stat_2 = IssueStatistic.last
      assert_equal stat_1.total, stat_2.total, 'Wrong total issues count!'
      assert_equal stat_1.closed, stat_2.closed, 'Wrong closed issues count!'
      assert_equal stat_1.opened, stat_2.opened, 'Wrong opened issues count!'
      assert_equal stat_1.opened_to_closed, stat_2.opened_to_closed, 'Wrong opened_to_closed ratio!'
      assert_equal stat_1.avg_issue_time, stat_2.avg_issue_time, 'Wrong avg_issue_time!'
      assert_equal stat_1.returned, stat_2.returned, 'Wrong returned issues count!'
    end
  end

  test 'returend_issues_count_on_status_change_in_journal_for_principal' do
    assert_difference 'JournalDetail.count', +2 do
      detail_on_test = JournalDetail.new
      detail_on_test.journal_id = 1
      detail_on_test.property = "attr"
      detail_on_test.prop_key = "status_id"
      detail_on_test.old_value = "2"
      detail_on_test.value = "7"
      assert detail_on_test.save, 'Can not save detail_on_test!'

      detail_from_test = JournalDetail.new
      detail_from_test.journal_id = 1
      detail_from_test.property = "attr"
      detail_from_test.prop_key = "status_id"
      detail_from_test.old_value = "7"
      detail_from_test.value = "1"
      assert detail_from_test.save, 'Can not save detail_from_test!'

      RedmineIssueStatistics::CalculateStatistic.new.calculate
      stat = IssueStatistic.last
      assert_equal 2, stat.returned, 'Wrong returned count!'
    end
  end

  test 'returned_issues_for_project' do
    assert_equal 0, IssueStatistic.count, 'Should be 0!'
    assert_difference 'IssueStatistic.count', +2 do
      RedmineIssueStatistics::CalculateStatistic.new.calculate
      stat_project = IssueStatistic.where(statisticable_type: "project").first
      assert_not_equal stat_project.total, nil, 'total Should not be null'
      assert_not_equal stat_project.returned, nil, 'returned Should not be null'
      assert_not_equal stat_project.closed, nil, 'closed Should not be null'
      assert_not_equal stat_project.opened, nil, 'opened Should not be null'
      assert_equal 1, stat_project.returned, 'Wrong returnd count'
    end
  end

  test 'AVG time per issue' do
    assert_difference 'IssueStatistic.count', +2 do
      RedmineIssueStatistics::CalculateStatistic.new.calculate
      stat_project =  IssueStatistic.where(statisticable_type: "project").first
      assert_equal 170.0, stat_project.avg_issue_time, 'Wrong avg_issue_time for project!' 
      stat_user = IssueStatistic.where(statisticable_type: "user").first
      assert_equal 170.0, stat_user.avg_issue_time, 'Wrong avg_issue_timem for user!'
    end
  end
end