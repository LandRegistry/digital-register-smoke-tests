require_relative 'test_variables'
require 'capybara/poltergeist'
require 'rspec'
require 'net/https'

include Capybara::DSL

RSpec.describe 'Smoke Tests' do

  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(
      app,
      inspector: true,
      timeout: 240,
      js_errors: false,
      phantomjs_options: [
        '--ignore-ssl-errors=yes',
        '--local-to-remote-url-access=yes',
        '--ssl-protocol=any'
      ]
    )
  end

  Capybara.default_driver = :poltergeist
  Capybara.javascript_driver = :poltergeist

  before :each do |test|
    unless test.metadata[:do_not_log_in]
      visit_login_page()
      page.fill_in 'username', with: $TEST_USERNAME
      page.fill_in 'password', with: $TEST_PASSWORD
      page.click_button('signin')
    end
  end

  after :each do |test|
    test.metadata[:do_not_log_in] || page.click_link('Sign out')
  end

  it 'checks the availability of the login page', :do_not_log_in do
    visit_landing_page()
    page.assert_text('Digital Register Login')
  end

  it 'can log in and out correctly', :do_not_log_in do
    visit_login_page()
    page.fill_in 'username', with: $TEST_USERNAME
    page.fill_in 'password', with: $TEST_PASSWORD
    page.click_button('signin')
    page.assert_text('Search for the title of any property in England and Wales')
    page.click_link('Sign out')
    page.assert_text('Digital Register Login')
  end

  it 'can search using a title number' do
    visit_title_search_page()
    page.fill_in 'search_term', with: $TEST_TITLE_NUMBER
    page.click_button('Search')
    page.assert_text("Summary of title #{$TEST_TITLE_NUMBER}")
  end

  it 'can navigate to the search page from title details' do
    visit_title_details_page($TEST_TITLE_NUMBER)
    page.assert_text('Summary of title')
    page.click_link('Find a title')
    page.assert_text('Search for the title of any property in England and Wales')
  end

  it 'can search using the postcode' do
    visit_title_search_page()
    page.fill_in 'search_term', with: $TEST_TITLE_POSTCODE
    page.click_button('Search')
    page.assert_text("#{$TEST_TITLE_NUMBER}")
  end

  it 'it can navigate to the correct title summary from the postcode search' do
    visit_title_search_page()
    page.fill_in 'search_term', with: $TEST_TITLE_POSTCODE
    page.click_button('Search')
    page.click_link($TEST_TITLE_SEARCH_RESULT_TEXT)
    page.assert_text("Summary of title #{$TEST_TITLE_NUMBER}")
  end

  it 'can search using an address string' do
    visit_title_search_page()
    page.fill_in 'search_term', with: $TEST_TITLE_ADDRESS_SEARCH_TERM
    page.click_button('Search')
    page.assert_text("#{$TEST_TITLE_NUMBER}")
  end

  it 'can navigate to the title summary from the address string search' do
    visit_title_search_page()
    page.fill_in 'search_term', with: $TEST_TITLE_ADDRESS_SEARCH_TERM
    page.click_button('Search')
    page.click_link($TEST_TITLE_SEARCH_RESULT_TEXT)
    page.assert_text("Summary of title #{$TEST_TITLE_NUMBER}")
  end
end

def visit_title_search_page()
  page.visit "#{$DIGITAL_REGISTER_URL}title-search"
end

def visit_title_details_page(title_number)
  page.visit "#{$DIGITAL_REGISTER_URL}titles/#{title_number}"
end

def visit_login_page()
  page.visit "#{$DIGITAL_REGISTER_URL}login"
end

def visit_landing_page()
  page.visit "#{$DIGITAL_REGISTER_URL}"
end
