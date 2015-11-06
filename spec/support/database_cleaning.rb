RSpec.configure do |config|

  # For use with the 'database_cleaner' gem. Disable transactions for the JavaScript
  # tests, and use data truncation instead. Rather than running each test in a transaction
  # block that’s rolled back after the test, data truncation does automatic wipe of the
  # database at the end of each test.
  # See also: spec/support/rails_helper.rb (config.use_transactional_fixtures = false)

  config.before(:suite) do
    DatabaseCleaner.strategy = :deletion
    DatabaseCleaner.clean_with(:deletion)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end