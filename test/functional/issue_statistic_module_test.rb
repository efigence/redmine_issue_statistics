require File.expand_path('../../test_helper', __FILE__)

include RedmineIssueStatistics

class IssueStatisticTest < ActiveSupport::TestCase
  self.fixture_path = File.join(File.dirname(__FILE__), '../fixtures')

  fixtures :issues,
           :journals, 
           :journal_details,  
           :users,
           :projects,
           :time_entries,
           :members


  test 'initial fixtures' do
    assert_equal 1, User.count, 'should be 1'
    assert_equal 6, Journal.count, 'should be 5'
    assert_equal 6, JournalDetail.count, 'should be 6'
    assert_equal 0, IssueStatistic.count, 'should be 0'
    assert_equal 1, Project.count, 'should be 1'
    assert_equal 2, TimeEntry.count, 'should be 2'
  end

  test 'IssueStatistic should be saved' do
    assert_difference 'IssueStatistic.count', +12 do
      RedmineIssueStatistics::CalculateStatistic.new.calculate 
    end
  end

  test 'Base calculation' do
    assert_difference 'IssueStatistic.count', +12 do
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

  test 'Returned issues calculation and on jorunal change' do
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
    assert_difference 'IssueStatistic.count', +12 do
      RedmineIssueStatistics::CalculateStatistic.new.calculate
      stat_project = IssueStatistic.where(statisticable_type: "project").first
      assert_not_equal stat_project.total, nil, 'total Should not be null'
      assert_not_equal stat_project.returned, nil, 'returned Should not be null'
      assert_not_equal stat_project.closed, nil, 'closed Should not be null'
      assert_not_equal stat_project.opened, nil, 'opened Should not be null'
      assert_equal 1, stat_project.returned, 'Wrong returned count'
    end
  end

  test 'AVG time per issue' do
    assert_difference 'IssueStatistic.count', +12 do
      RedmineIssueStatistics::CalculateStatistic.new.calculate
      stat_project =  IssueStatistic.where(statisticable_type: "project").first
      assert_equal 170.0, stat_project.avg_issue_time, 'Wrong avg_issue_time for project!' 
      stat_user = IssueStatistic.where(statisticable_type: "user").first
      assert_equal 170.0, stat_user.avg_issue_time, 'Wrong avg_issue_timem for user!'
    end
  end

  test 'Comment count greater then 5' do
    assert_difference 'IssueStatistic.count', +12 do
      RedmineIssueStatistics::CalculateStatistic.new.calculate
      stat = IssueStatistic.where(period: 'week').first
      stat_month = IssueStatistic.where(period: 'month').first
      stat_year = IssueStatistic.where(period: 'year').first
      assert_equal 0, stat.comment_max, 'Wrong comment count for week!'
      assert_equal 1, stat_month.comment_max, 'Wrong comment count for month!' 
      assert_equal 1, stat_year.comment_max, 'Wrong comment count for year!' 
    end
  end

  test 'week, month, year, all' do
    assert_difference 'IssueStatistic.count', +12 do
      RedmineIssueStatistics::CalculateStatistic.new.calculate
      stat_week = IssueStatistic.where(period: 'week').first
      stat_month = IssueStatistic.where(period: 'month').first
      stat_year = IssueStatistic.where(period: 'year').first
      stat_all = IssueStatistic.where(period: 'all').first
      assert_equal 1, stat_week.returned, "Wrong returned count for stat_week"
      assert_equal 1, stat_month.returned, "Wrong returned count for stat_month"
      assert_equal 1, stat_year.returned, "Wrong returned count for stat_year"
      assert_equal 1, stat_all.returned, "Wrong returned count for stat_all"
    end
  end
  
  test 'Statistics for principal per project' do
    RedmineIssueStatistics::CalculateStatistic.new.calculate
    stat_week = IssueStatistic.where("period = ? AND relate_type = ?", "week", "User").first
    stat_month = IssueStatistic.where("period = ? AND relate_type = ?", "month", "User").first
    stat_year = IssueStatistic.where("period = ? AND relate_type = ?", "year", "User").first
    stat_all = IssueStatistic.where("period = ? AND relate_type = ?", "all", "User").first
    assert_equal 1, stat_week.total, "Wrong total count in stat_week!"
    assert_equal 1, stat_month.total, "Wrong total count in stat_month!"
    assert_equal 1, stat_year.total, "Wrong total count in stat_year!"
    assert_equal 1, stat_all.total, "Wrong total count in stat_all!"
    assert_equal 0, stat_week.comment_max, "Wrong comment count in stat_week!"
    assert_equal 1, stat_month.comment_max, "Wrong comment count in stat_month!"
    assert_equal 1, stat_year.comment_max, "Wrong comment count in stat_year!"
    assert_equal 1, stat_all.comment_max, "Wrong comment count in stat_all!"
    assert_equal 1, stat_all.returned, "Wrong returned count in stat_all!"
  end

  test 'Recalculete statistic for returned issues ratio' do
    RedmineIssueStatistics::CalculateStatistic.new.calculate
    stat_week = IssueStatistic.where("period = ? AND relate_type = ?", "week", "User").first
    stat_month = IssueStatistic.where("period = ? AND relate_type = ?", "month", "User").first
    stat_year = IssueStatistic.where("period = ? AND relate_type = ?", "year", "User").first
    stat_all = IssueStatistic.where("period = ? AND relate_type = ?", "all", "User").first 
    assert_equal 100.0, stat_week.returned_ratio
    assert_equal 100.0, stat_month.returned_ratio
    assert_equal 100.0, stat_year.returned_ratio
    assert_equal 100.0, stat_all.returned_ratio
  end

  test 'Old tasks' do
    RedmineIssueStatistics::CalculateStatistic.new.calculate
    stat_week = IssueStatistic.where("period = ? AND relate_type = ?", "week", "User").first
    assert_equal 0, stat_week.old_issues, "Wrong older then week issues count"
  end

end