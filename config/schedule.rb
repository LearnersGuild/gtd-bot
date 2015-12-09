set :output, 'log/reports.log'

every :sunday, at: '12pm' do
  runner "Reports::Runner.perform"
end
