require_relative "stats/calculate_statistic_for_principal"
require_relative "stats/calculate_statistic_for_project"

module RedmineIssueStatistics

  class CalculateStatistic
    def calculate
      calculate_stats_for_project
      # calculate_stats_for_principal
    end

    private

    def calculate_stats_for_project
      CalculateStatisticForProject.new.calculate
    end

    def calculate_stats_for_principal
      CalculateStatisticForPrincipal.new.calculate
    end
  end
end