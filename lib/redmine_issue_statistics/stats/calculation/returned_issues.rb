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
    returned = 0
      if statisticable.issues.any?
        statisticable.issues.each do |issue|
          issue.journals.each do |journal|
          journal.details.where(prop_key: "status_id").each do |detail|
            value = nil
              value = ["1", "2", "8"].find{ |x| x == detail.value} 
              unless value.nil?
                returned += 1
              end
            end
          end
        end
        @results[:returned] = returned
      end
    end
  end
end