#redmine_issue_statistics/stats/calculation/base_calculation
module RedmineIssueStatistics
  class BaseCalculation
    attr_reader :results

    def calculate statisticable
      calculate_total_issues_for statisticable
      calculate_opened_issues_for statisticable
      calculate_closed_issues_for statisticable
      calculate_ration_opened_to_closed_for statisticable
      calculate_avg_issue_time_for statisticable
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

    def calculate_closed_issues_for(statisticable)
      closed = 0
      statisticable.issues.each do |issue|
        if issue.closed?  
          closed += 1
        end  
      end
      @results[:closed] = closed 
    end

    def calculate_ration_opened_to_closed_for(statisticable)
      opened = @results[:opened]
      closed = @results[:closed]
      if opened != 0 && closed != 0
        ratio = opened/closed.to_f
        @results[:opened_to_closed] = ratio * 100
      elsif opened == 0 && closed != 0
        @results[:opened_to_closed] = 100
      else
        @results[:opened_to_closed] = 0
      end
    end

    def calculate_avg_issue_time_for(statisticable)
      spent_hours_sum = statisticable.issues.map(&:spent_hours).reduce(:+)
      total = @results[:total]
      @results[:avg_issue_time] = total > 0 ? spent_hours_sum/total : 0
    end
  end
end