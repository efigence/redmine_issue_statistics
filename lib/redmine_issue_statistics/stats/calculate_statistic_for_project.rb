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

    def existing_stats project
      IssueStatistic.where(statisticable_id: project.id, statisticable_type: project.class.name).first
    end

    def new_stat project
      s = IssueStatistic.new
      s.statisticable_id = project.id
      s.statisticable_type = project.class.name
      s
    end

    def save_results project
      stat = existing_stats(project) || new_stat(project) 
      stat.update_attributes merged_results
    end
  end
end