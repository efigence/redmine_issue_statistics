require_relative "calculation/base_calculation"

module RedmineIssueStatistics

  class CalculateStatisticForProject
    
    def calculate
      Project.find_each do |project|
        res = BaseCalculation.calculate project
        save_res(@results)
      end
    end

    def save_res(results)
      stat = IssueStatitic.new(results)
      stat.save
    end
  end
end