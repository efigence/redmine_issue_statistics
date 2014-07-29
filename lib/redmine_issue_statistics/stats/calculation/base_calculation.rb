#redmine_issue_statistics/stats/calculation/base_calculation
module RedmineIssueStatistics
  class BaseCalculation
    attr_reader :results

    def calculate statisticable
      calculate_total_issues_for statisticable
      calculate_opened_issues_for statisticable
      return @results
    end

    private 

    def initialize
      @results = {}
    end

    def calculate_total_issues_for(statisticable)
      @results[:total] = statisticable.issues.count
    end

    def calculate_opened_issues_for(statisticable)
      @results[:opened] = statisticable.issues.open.count
    end
  end
end