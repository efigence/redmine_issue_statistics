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

    def save_results principal
      stat = IssueStatistic.new( merged_results )
      stat.statisticable_id = principal.id
      stat.statisticable_type = principal.class.name
      puts stat.inspect
      stat.save
    end
  end
end