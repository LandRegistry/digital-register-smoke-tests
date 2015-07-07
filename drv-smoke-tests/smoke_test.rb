require_relative 'test_variables'
require 'capybara/poltergeist'
require 'rspec'

RSpec.describe 'Smoke Tests' do
  session = Capybara::Session.new(:poltergeist)

  before :each do |test|
    unless test.metadata[:do_not_log_in]
      session.visit "#{$DIGITAL_REGISTER_URL}login"
      session.fill_in 'username', with: $TEST_USERNAME
      session.fill_in 'password', with: $TEST_PASSWORD
      session.click_button('signin')
    end
  end

  after :each do |test|
    test.metadata[:do_not_log_in] || session.click_link('Sign out')
  end

  it 'checks the availability of the login page', :do_not_log_in do
    visit_landing_page(session)
    session.assert_text('Digital Register Login')
  end

  it 'can log in and out correctly', :do_not_log_in do
    visit_login_page(session)
    session.fill_in 'username', with: $TEST_USERNAME
    session.fill_in 'password', with: $TEST_PASSWORD
    session.click_button('signin')
    session.assert_text('Search for the title of any property in England and Wales')
    session.click_link('Sign out')
    session.assert_text('Digital Register Login')
  end

  it 'Can search using a title number' do
    visit_title_search_page(session)
    session.fill_in 'search_term', with: $TEST_TITLE_NUMBER
    session.click_button('Search')
    session.assert_text("Summary of title #{$TEST_TITLE_NUMBER}")
  end

  it 'it can navigate back to the search page' do
    visit_title_details_page(session, $TEST_TITLE_NUMBER)
    session.assert_text('Summary of title')
    session.click_link('Find a title')
    session.assert_text('Search for the title of any property in England and Wales')
  end

  it 'Can search using the postcode' do
    visit_title_search_page(session)
    session.fill_in 'search_term', with: $TEST_TITLE_POSTCODE
    session.click_button('Search')
    session.assert_text("#{$TEST_TITLE_NUMBER}")
  end

  it 'it can navigate to the correct title summary from the postcode search' do
    visit_title_search_page(session)
    session.fill_in 'search_term', with: $TEST_TITLE_POSTCODE
    session.click_button('Search')
    session.click_link($TEST_TITLE_SEARCH_RESULT_TEXT)
    session.assert_text("Summary of title #{$TEST_TITLE_NUMBER}")
  end

  it 'can navigate back to the search page' do
    visit_title_details_page(session, $TEST_TITLE_NUMBER)
    session.click_link('Find a title')
    session.assert_text('Search for the title of any property in England and Wales')
  end

  it 'can search using an address string' do
    visit_title_search_page(session)
    session.fill_in 'search_term', with: $TEST_TITLE_ADDRESS_SEARCH_TERM
    session.click_button('Search')
    session.assert_text("#{$TEST_TITLE_NUMBER}")
  end

  it 'can navigate to the title summary from the address string search' do
    visit_title_search_page(session)
    session.fill_in 'search_term', with: $TEST_TITLE_ADDRESS_SEARCH_TERM
    session.click_button('Search')
    session.click_link($TEST_TITLE_SEARCH_RESULT_TEXT)
    session.assert_text("Summary of title #{$TEST_TITLE_NUMBER}")
  end
end

def visit_title_search_page(session)
  session.visit "#{$DIGITAL_REGISTER_URL}title-search"
end

def visit_title_details_page(session, title_number)
  session.visit "#{$DIGITAL_REGISTER_URL}titles/#{title_number}"
end

def visit_login_page(session)
  session.visit "#{$DIGITAL_REGISTER_URL}login"
end

def visit_landing_page(session)
  session.visit "#{$DIGITAL_REGISTER_URL}"
end
