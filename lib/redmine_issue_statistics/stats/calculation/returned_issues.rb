module RedmineIssueStatistics
  class ReturnedIssues
    attr_reader :results, :period

    def calculate statisticable, period
      @periods_datetime = nil
      @period = period

      returned_issues statisticable
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

    def returned_issues(statisticable)
    returned = 0
      if statisticable.issues.any?
        statisticable.issues.each do |issue|
          issue.journals.where('created_on >= ?', period_to_datetime).each do |journal|
            journal.details.where(prop_key: "status_id").each do |detail|
              if detail.old_value != "1"
                value = ["1", "2", "8"].find{ |x| x == detail.value} 
                unless value.nil?
                  returned += 1
                  break
                end
              end
            end
          end
        end
        @results[:returned] = returned
      end
    end
  end
end