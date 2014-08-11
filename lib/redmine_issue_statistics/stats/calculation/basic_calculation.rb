module RedmineIssueStatistics
  class BasicCalculation

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
            period = 1000.years.ago
          end
          @periods_datetime = period
        end
        @periods_datetime ||= period
      end

  end
end