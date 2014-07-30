
module RedmineIssueStatistics
  class ReturnedIssues
    attr_reader :results

    def calculate statisticable
      returned_issues statisticable
      return @results
    end

    private 

    def initialize
      @results = {}
    end

    def returned_issues(statisticable)
      @results[:returned] = 0
      # statisticable.issues.each do |issue|
      #   issue.journals.each do |journal|
      #     journal.details.where(prop_key: "status_id").each do |detail|
      #       if detail.old_val
      #       end
      #     end
      #   end
      # end
    end

  end
end