namespace :issue_statistics do
  desc "Calculations"
  task :calculate => :environment do
    puts "Calculations start - It's can take a while..."
    RedmineIssueStatistics::CalculateStatistic.new.calculate
    puts "Calculations done"
  end
end