module RedmineIssueStatistics
  class ReturnedIssues
    attr_reader :results, :period

    def calculate statisticable, period, scope = nil
      @periods_datetime = nil
      @period = period
      @scope = scope
      @query =  statisticable.issues.where('issues.created_on >= ?', period_to_datetime)
      returned_issues_and_comment_max statisticable
      returned statisticable
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
      @returned = 0
      @comment_count = 0
    end
    
    def project_scope
      if @scope
        @query = @query.where(project_id: @scope)
      end
    end
    
    def returned_issues_and_comment_max(statisticable)
      if statisticable.issues.any?
        project_scope
        @query.each do |issue|
          comment(issue.id)
        end
        @results[:comment_max] = @comment_count
      end
    end

    def comment issue
      comments = Journal.where("journalized_id = ? AND notes != ? AND created_on >= ?", issue, "", period_to_datetime).count
      @comment_count += 1 if comments > 5
    end

    def returned statisticable
      if statisticable.issues.any?
        project_scope
        @returned = @query.joins(journals: :details).select('journalized_id, old_value, value').where('old_value != ? AND value IN(?) AND prop_key = ?', 1, ["1","2","8"], "status_id").count
        @results[:returned] = @returned
      end
    end
  end
end