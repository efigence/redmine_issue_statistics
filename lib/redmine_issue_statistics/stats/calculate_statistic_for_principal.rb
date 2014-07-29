require_relative "calculation/base_calculation"

module RedmineIssueStatistics
  
  class CalculateStatisticForPrincipal
    
    def calculate
      Principal.find_each do |principal|
        res = BaseCalculation.calculate principal
        save_res(@results)
      end
    end

    def save_res(results)
      stat = IssueStatitic.new(results)
      stat.save
    end
  end  
end