require_relative "./basic_calculation"

module RedmineIssueStatistics
	class JournalCalculation < BasicCalculation
		attr_reader :results, :period

		def calculate statisticable, period, scope = nil
			@periods_datetime = nil
			@period = period
			@scope = scope

			issues_logged_statisticable statisticable, period_to_datetime if statisticable.class.name != "Project"
			opened_by_journal statisticable, period_to_datetime if statisticable.class.name != "Project"

			return @results
		end

		private

		def initialize
			@results = {}
		end

		def issues_logged_statisticable statisticable, period_to_datetime
			if @scope == nil
				@total = Queries.total_logged_to statisticable, period_to_datetime
				@results[:total_assigned] = @total.count
			else
				@total = Queries.total_logged_to statisticable, period_to_datetime, @scope
				@results[:total_assigned] = @total.count
			end
		end

		def opened_by_journal statisticable, period_to_datetime
			if @scope == nil
				@opened = Queries.opened_by_journal_query statisticable, period_to_datetime
				@results[:opened] = @opened.count unless @opened.nil?
				@results[:opened] = 0 if @opened.nil?
			else
				@opened = Queries.opened_by_journal_query statisticable, period_to_datetime, @scope
				@results[:opened] = @opened.count unless @opened.nil?
				@results[:opened] = 0 if @opened.nil?
			end
		end
	end
end
