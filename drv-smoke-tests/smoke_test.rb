require_relative 'test_variables'
require 'capybara'
require 'capybara/poltergeist'
require 'rspec'
require 'openssl'
require 'rspec/expectations'
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

  #page = Capybara::page.new(:poltergeist)


  before :each do |test|
    unless test.metadata[:do_not_log_in]
      visit_login_page(page)
      page.fill_in 'username', with: $TEST_USERNAME
      page.fill_in 'password', with: $TEST_PASSWORD
      page.click_button('signin')
    end
  end

  after :each do |test|
    page.save_screenshot('error.png')
    test.metadata[:do_not_log_in] || page.click_link('Sign out')
  end

  it 'checks the availability of the login page', :do_not_log_in do
    visit_landing_page(page)
    page.assert_text('Digital Register Login')
  end

  it 'can log in and out correctly', :do_not_log_in do
    visit_login_page(page)
    page.fill_in 'username', with: $TEST_USERNAME
    page.fill_in 'password', with: $TEST_PASSWORD
    page.click_button('signin')
    page.assert_text('Search for the title of any property in England and Wales')
    page.click_link('Sign out')
    page.assert_text('Digital Register Login')
  end

  it 'Can search using a title number' do
    visit_title_search_page(page)
    page.fill_in 'search_term', with: $TEST_TITLE_NUMBER
    page.click_button('Search')
    page.assert_text("Summary of title #{$TEST_TITLE_NUMBER}")
  end

  it 'it can navigate back to the search page' do
    visit_title_details_page(page, $TEST_TITLE_NUMBER)
    page.assert_text('Summary of title')
    page.click_link('Find a title')
    page.assert_text('Search for the title of any property in England and Wales')
  end


end

def visit_title_search_page(page)
  page.visit "https://digital.integration.beta.landregistryconcept.co.uk/title-search"
end

def visit_title_details_page(page, title_number)
  page.visit "https://digital.integration.beta.landregistryconcept.co.uk/titles/#{title_number}"
end

def visit_login_page(page)
  page.visit "https://digital.integration.beta.landregistryconcept.co.uk/login"
end

def visit_landing_page(page)
  page.visit "https://digital.integration.beta.landregistryconcept.co.uk/"
end
