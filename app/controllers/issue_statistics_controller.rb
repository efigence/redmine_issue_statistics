class IssueStatisticsController < ApplicationController
  unloadable
  #include Statistics

  def index
  	@issue_statistics = IssueStatistic.all
  end

end
