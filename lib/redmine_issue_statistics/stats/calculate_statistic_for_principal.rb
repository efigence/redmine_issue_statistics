require_relative "calculation/base_calculation"
require_relative "calculation/returned_issues"

module RedmineIssueStatistics
  
  class CalculateStatisticForPrincipal

    attr_reader :results
    
    def calculate
      Principal.find_each do |principal|
        @results = []
        @results << BaseCalculation.new.calculate(principal)
        @results << ReturnedIssues.new.calculate(principal)
        save_results principal
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

   def existing_stats principal
      IssueStatistic.where(statisticable_id: principal.id, statisticable_type: principal.class.name).first
    end

    def new_stat principal
      s = IssueStatistic.new
      s.statisticable_id = principal.id
      s.statisticable_type = principal.class.name
      s
    end

    def save_results principal
      stat = existing_stats(principal) || new_stat(principal) 
      stat.update_attributes merged_results
    end
  end
end