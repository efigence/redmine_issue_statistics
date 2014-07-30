require_relative "calculation/base_calculation"
require_relative "calculation/returned_issues"

module RedmineIssueStatistics

  class CalculateStatisticForProject

    attr_reader :results
    
    def calculate
      Project.find_each do |project|
        @results = []
        @results << BaseCalculation.new.calculate(project)
        @results << ReturnedIssues.new.calculate(project)
        save_results project
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

    def save_results project
      stat = IssueStatistic.new( merged_results )
      stat.statisticable_id = project.id
      stat.statisticable_type = project.class.name
      #puts stat.inspect
      stat.save
    end
  end
end