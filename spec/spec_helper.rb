RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.order = :random

  config.before(:each) do
    mock_logger = Logger.new("/dev/null")
    allow_any_instance_of(BaseService).to receive(:logger)
      .and_return(mock_logger)
  end
end
