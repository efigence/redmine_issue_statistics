module RedmineIssueStatistics
  class ReturnedIssues
    attr_reader :results, :period

    def calculate statisticable, period, scope = nil
      @periods_datetime = nil
      @period = period
      @scope = scope
      @query =  statisticable.issues.where('created_on >= ?', period_to_datetime)
      returned_issues_and_comment_max statisticable
      return @results
    end

    private 

    def period_to_datetime
      unless @periods_datetime
        period = nil
        case @period
          when 'week'
            period = 1.week.ago
          when 'month'
            period = 1.month.ago
          when 'year'
            period = 1.year.ago
          when 'all'
            period = 100.years.ago
          end
        @periods_datetime = period
      end
      @periods_datetime ||= period
    end

    def initialize
      @results = {} 
    end

    def returned_issues_and_comment_max(statisticable)
    returned = 0
    comment_count = 0
    tab = []
      if statisticable.issues.any?
        if @scope
          @query = @query.where(project_id: @scope)
        end
        @query.each do |issue|
          comment = 0  
          issue.journals.where('created_on >= ?', period_to_datetime).each do |journal|
            if journal.notes != ""
              comment += 1
              if comment > 5
                comment_count += 1
                break
              end
            end
            if journal.details.where("prop_key = ? AND old_value != ? AND value IN(?)", "status_id", 1, ["1", "2", "8"] ).any?
              returned += 1
            end
          end
        end
        @results[:comment_max] = comment_count
        @results[:returned] = returned
      end
    end
  end
end