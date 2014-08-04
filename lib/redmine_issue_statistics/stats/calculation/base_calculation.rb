#redmine_issue_statistics/stats/calculation/base_calculation
module RedmineIssueStatistics
  class BaseCalculation
    attr_reader :results, :period

    def calculate statisticable, period
      @periods_datetime = nil
      @period = period

      calculate_total_issues_for statisticable
      calculate_opened_issues_for statisticable
      calculate_closed_issues_for statisticable
      calculate_done_for statisticable
      calculate_avg_issue_time_for statisticable
      return @results
    end

    private 

    def period_to_datetime
      unless @periods_datetime
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
      @periods_datetime ||= period
    end

    def initialize
      @results = {}
    end

    def calculate_total_issues_for(statisticable)
      @results[:total] = statisticable.issues.where('created_on >= ?', period_to_datetime).count
    end

    def calculate_opened_issues_for(statisticable)
      @results[:opened] = statisticable.issues.where('created_on >= ?', period_to_datetime).open.count
    end

    def calculate_closed_issues_for(statisticable)
      closed = 0
      statisticable.issues.where('created_on >= ?', period_to_datetime).each do |issue|
        if issue.closed?  
          closed += 1
        end  
      end
      @results[:closed] = closed 
    end

    def calculate_done_for(statisticable)
      opened = @results[:opened]
      closed = @results[:closed]
      if opened != 0 && closed != 0
        ratio = opened/(opened+closed).to_f
        @results[:opened_to_closed] = 100 - ratio * 100
      elsif opened == 0 && closed != 0
        @results[:opened_to_closed] = 100
      else
        @results[:opened_to_closed] = 0
      end
    end

    def calculate_avg_issue_time_for(statisticable)
      spent_hours_sum = statisticable.issues.where('created_on >= ?', period_to_datetime).map(&:spent_hours).reduce(:+)
      total = @results[:total]
      @results[:avg_issue_time] = total > 0 ? spent_hours_sum/total : 0
    end
  end
end