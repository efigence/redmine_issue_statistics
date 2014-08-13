require_relative "calculation/base_calculation"
require_relative "calculation/returned_issues"

module RedmineIssueStatistics

  class CalculateStatisticForProject

    attr_reader :results, :period
    
    def calculate periods
     Project.find_each do |project|
     #Project.where(id: 4).each do |project|
        periods.each do |period|
          calculate_with_params(project, period)
          save_results project, period
          calculate_principal_per_project(project, period)
        end
        #return
      end
    end

    private
    
    def calculate_with_params value, period, scope = nil
       @results = []
       @results << BaseCalculation.new.calculate(value, period, scope)
       @results << ReturnedIssues.new.calculate(value, period, scope)
    end

    def calculate_principal_per_project project, period
      project.principals.find_each do |principal|
        calculate_with_params(principal, period, project.id)
        save_results_per_project principal, project, period
        #return
      end
    end

    def merged_results
      @results.inject do |res, n| 
        res ||= {}
        res.merge n
      end
    end

    def existing_stats project, period
      IssueStatistic.where(statisticable_id: project.id, statisticable_type: project.class.name, period: period).first
    end

    def params_to_save(value)
      s = IssueStatistic.new
      s.statisticable_id = value.id
      s.statisticable_type = value.class.name
      s
    end

    def new_stat project
      params_to_save(project)
    end

    def save_results project, period
      stat = existing_stats(project, period) || new_stat(project) 
      stat.period = period
      stat.update_attributes merged_results
    end

    def new_stat_per_project project, principal
      s = params_to_save(principal)
      s.relate_id = project.id
      s.relate_type = project.class.name
      s.update_attributes merged_results
      s
    end
    
    def existing_stats_per_project principal, project, period
      IssueStatistic.where(statisticable_id: project.id, statisticable_type: project.class.name, period: period,
                           relate_id: principal.id, relate_type: principal.class.name).first
    end

    def save_results_per_project principal, project, period
      stat = existing_stats_per_project(principal, project, period) || new_stat_per_project(principal, project) 
      stat.period = period
      stat.update_attributes merged_results
    end
  end
end