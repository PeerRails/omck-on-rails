require "omniauth"
require "factory_girl_rails"
require "faker"
require "shoulda-matchers"
require 'simplecov'
require 'simplecov-json'
require 'simplecov-rcov'
require 'webmock/rspec'
require "cancan/matchers"
require "pundit/rspec"
require 'coveralls'
require "codeclimate-test-reporter"

# WebMock for Bitly and Twitter
WebMock.enable!
WebMock.disable_net_connect!(allow: 'https://codeclimate.com')

# Test Coverage
SimpleCov.formatters = [
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::JSONFormatter,
  Coveralls::SimpleCov::Formatter,
  SimpleCov::Formatter::RcovFormatter,
]
SimpleCov.start 'rails' do
  add_filter "app/controllers/nginx_controller.rb"
  add_group "Serializers", "app/serializers"
  add_group "Policies", "app/policies"
end
CodeClimate::TestReporter.start

ENV["TICKET_1"] = "t1"
ENV["TICKET_2"] = "t2"
ENV["TICKET_3"] = "t3"
ENV["TICKET_4"] = "t4"
ENV["LOGIN_AUTH"] = "la"
ENV["LOGIN_SECRET"] = "ls"
ENV["TWITCH_ID"] = "tid"
ENV["BITLY_USER"] = "bu"
ENV["BITLY_TOKEN"] = "bt"

OmniAuth.config.test_mode = true
omni_twitter = {
  :provider => "twitter",
  :uid => "123456",
  :info => {
    :nickname => "johnqpublic",
    :name => "John Q Public",
    :location => "Anytown, USA",
    :image => "http://si0.twimg.com/sticky/default_profile_images/default_profile_2_normal.png",
    :description => "a very normal guy.",
    :urls => {
      :Website => nil,
      :Twitter => "https://twitter.com/johnqpublic"
    }
  },
  :credentials => {
    :token => "a1b2c3d4...", # The OAuth 2.0 access token
    :secret => "abcdef1234"
  },
  :extra => {
    :access_token => "", # An OAuth::AccessToken object
    :raw_info => {
      :name => "John Q Public",
      :listed_count => 0,
      :profile_sidebar_border_color => "181A1E",
      :url => nil,
      :lang => "en",
      :statuses_count => 129,
      :profile_image_url => "http://si0.twimg.com/sticky/default_profile_images/default_profile_2_normal.png",
      :profile_background_image_url_https => "https://twimg0-a.akamaihd.net/profile_background_images/229171796/pattern_036.gif",
      :location => "Anytown, USA",
      :time_zone => "Chicago",
      :follow_request_sent => false,
      :id => 123456,
      :profile_background_tile => true,
      :profile_sidebar_fill_color => "666666",
      :followers_count => 1,
      :default_profile_image => false,
      :screen_name => "",
      :following => false,
      :utc_offset => -3600,
      :verified => false,
      :favourites_count => 0,
      :profile_background_color => "1A1B1F",
      :is_translator => false,
      :friends_count => 1,
      :notifications => false,
      :geo_enabled => true,
      :profile_background_image_url => "http://twimg0-a.akamaihd.net/profile_background_images/229171796/pattern_036.gif",
      :protected => false,
      :description => "a very normal guy.",
      :profile_link_color => "2FC2EF",
      :created_at => "Thu Jul 4 00:00:00 +0000 2013",
      :id_str => "123456",
      :profile_image_url_https => "https://si0.twimg.com/sticky/default_profile_images/default_profile_2_normal.png",
      :default_profile => false,
      :profile_use_background_image => false,
      :entities => {
        :description => {
          :urls => []
        }
      },
      :profile_text_color => "666666",
      :contributors_enabled => false
    }
  }
}
OmniAuth.config.add_mock(:twitter, omni_twitter)

=begin
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
=end

RSpec.configure do |config|
  # rspec-expectations config goes here. You can use an alternate
  # assertion/expectation library such as wrong or the stdlib/minitest
  # assertions if you prefer.
  config.expect_with :rspec do |expectations|
    # This option will default to `true` in RSpec 4. It makes the `description`
    # and `failure_message` of custom matchers include text for helper methods
    # defined using `chain`, e.g.:
    #     be_bigger_than(2).and_smaller_than(4).description
    #     # => "be bigger than 2 and smaller than 4"
    # ...rather than:
    #     # => "be bigger than 2"
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended, and will default to
    # `true` in RSpec 4.
    mocks.verify_partial_doubles = true
  end
  config.include FactoryGirl::Syntax::Methods

# The settings below are suggested to provide a good initial experience
# with RSpec, but feel free to customize to your heart's content.
=begin
  # These two settings work together to allow you to limit a spec run
  # to individual examples or groups you care about by tagging them with
  # `:focus` metadata. When nothing is tagged with `:focus`, all examples
  # get run.
  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  # Allows RSpec to persist some state between runs in order to support
  # the `--only-failures` and `--next-failure` CLI options. We recommend
  # you configure your source control system to ignore this file.
  config.example_status_persistence_file_path = "spec/examples.txt"

  # Limits the available syntax to the non-monkey patched syntax that is
  # recommended. For more details, see:
  #   - http://rspec.info/blog/2012/06/rspecs-new-expectation-syntax/
  #   - http://www.teaisaweso.me/blog/2013/05/27/rspecs-new-message-expectation-syntax/
  #   - http://rspec.info/blog/2014/05/notable-changes-in-rspec-3/#zero-monkey-patching-mode
  config.disable_monkey_patching!

  # Many RSpec users commonly either run the entire suite or an individual
  # file, and it's useful to allow more verbose output when running an
  # individual spec file.
  if config.files_to_run.one?
    # Use the documentation formatter for detailed output,
    # unless a formatter has already been configured
    # (e.g. via a command-line flag).
    config.default_formatter = 'doc'
  end

  # Print the 10 slowest examples and example groups at the
  # end of the spec run, to help surface which specs are running
  # particularly slow.
  config.profile_examples = 10

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = :random

  # Seed global randomization in this process using the `--seed` CLI option.
  # Setting this allows you to use `--seed` to deterministically reproduce
  # test failures related to randomization by passing the same `--seed` value
  # as the one that triggered the failure.
  Kernel.srand config.seed
=end
end
