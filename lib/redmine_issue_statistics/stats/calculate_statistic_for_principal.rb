require_relative "calculation/base_calculation"
require_relative "calculation/returned_issues"

module RedmineIssueStatistics
  
  class CalculateStatisticForPrincipal

    attr_reader :results, :period
    
    def calculate periods
     Principal.find_each do |principal|
      #Principal.where(id: 95).each do |principal|
        periods.each do |period|
          @results = []
          @results << BaseCalculation.new.calculate(principal, period)
          @results << ReturnedIssues.new.calculate(principal, period)
          save_results principal, period
        end
        return
      end
    end

    private

    def merged_results
      @results.inject do |res, n| 
        res ||= {}
        res.merge n
      end
    end

    def existing_stats principal, period
      IssueStatistic.where(statisticable_id: principal.id, statisticable_type: principal.class.name, period: period).first
    end

    def new_stat principal
      s = IssueStatistic.new
      s.statisticable_id = principal.id
      s.statisticable_type = principal.class.name
      s
    end

    def save_results principal, period
      stat = existing_stats(principal, period) || new_stat(principal) 
      stat.period = period
      stat.update_attributes merged_results
    end
  end
end    



