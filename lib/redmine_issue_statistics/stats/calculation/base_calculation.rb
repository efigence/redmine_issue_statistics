#redmine_issue_statistics/stats/calculation/base_calculation
require_relative "./basic_calculation"

module RedmineIssueStatistics
  class BaseCalculation < BasicCalculation
    attr_reader :results, :period

    def calculate statisticable, period, scope = nil
      @periods_datetime = nil
      @period = period
      @scope = scope
      @query = statisticable.issues.where('created_on >= ?', period_to_datetime)

      calculate_total_issues_for statisticable
      calculate_opened_issues_for statisticable
      calculate_closed_issues_for statisticable
      calculate_done_for statisticable
      calculate_avg_issue_time_for statisticable
      return @results
    end

    private 

    def initialize
      @results = {}
    end

    def project_scope
      if @scope
        @query = @query.where(project_id: @scope)
      end
    end
    
    def calculate_total_issues_for(statisticable)
      project_scope
      @results[:total] = @query.count
    end

    def calculate_opened_issues_for(statisticable)
      project_scope
      @results[:opened] = @query.open.count
    end

    def calculate_closed_issues_for(statisticable)
      closed = 0
      project_scope
      @query.each do |issue|
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
      project_scope
      spent_hours_sum = @query.map(&:spent_hours).reduce(:+)
      total = @results[:total]
      @results[:avg_issue_time] = total > 0 ? spent_hours_sum/total : 0
    end
  end
end