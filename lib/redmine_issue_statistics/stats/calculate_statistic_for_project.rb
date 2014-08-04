require_relative "calculation/base_calculation"
require_relative "calculation/returned_issues"

module RedmineIssueStatistics

  class CalculateStatisticForProject

    attr_reader :results, :period
    
    def calculate periods
      Project.find_each do |project|
        periods.each do |period|
          @results = []
          @results << BaseCalculation.new.calculate(project, period)
          @results << ReturnedIssues.new.calculate(project, period)
          save_results project, period
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

    def existing_stats project, period
      IssueStatistic.where(statisticable_id: project.id, statisticable_type: project.class.name, period: period).first
    end

    def new_stat project
      s = IssueStatistic.new
      s.statisticable_id = project.id
      s.statisticable_type = project.class.name
      s
    end

    def save_results project, period
      stat = existing_stats(project, period) || new_stat(project) 
      stat.period = period
      stat.update_attributes merged_results
    end
  end
end