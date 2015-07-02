require_relative 'test_variables'
require 'capybara/poltergeist'
require 'rspec'
session = Capybara::Session.new(:poltergeist)

RSpec.describe 'Smoke Tests' do
  session.visit "#{$DIGITAL_REGISTER_URL}"

  it 'checks the availability of the login page' do
    session.assert_text('Login')
  end

  it 'can log in correctly' do
    session.fill_in 'username', with: $SMOKE_USERNAME
    session.fill_in 'password', with: $SMOKE_PASSWORD
    session.click_button('signin')
    session.assert_text('Search for the title of any property in England and Wales')
  end

  it 'Can search using a title number' do
    session.fill_in 'search_term', with: $SMOKE_TITLE_NUMBER
    session.click_button('Search')
    session.assert_text("#{$SMOKE_TITLE_NUMBER}")
  end

  it 'it immediately views the title summary page' do
    session.assert_text("Summary of title #{$SMOKE_TITLE_NUMBER}")
  end

  it 'it can navigate back to the search page' do
    session.click_link('Find a title')
    session.assert_text('Search for the title of any property in England and Wales')
  end

  it 'Can search using the postcode' do
    session.fill_in 'search_term', with: $SMOKE_POSTCODE
    session.click_button('Search')
    session.assert_text("#{$SMOKE_TITLE_NUMBER}")
  end

  it 'it can navigate to the correct title summary from the postcode search' do
    session.click_link($SMOKE_PARTIAL_ADDRESS)
    session.assert_text("Summary of title #{$SMOKE_TITLE_NUMBER}")
  end

  it 'can navigate back to the search page' do
    session.click_link('Find a title')
    session.assert_text('Search for the title of any property in England and Wales')
  end

  it 'can search using an address string' do
    session.fill_in 'search_term', with: $SMOKE_PARTIAL_ADDRESS
    session.click_button('Search')
    session.assert_text("#{$SMOKE_TITLE_NUMBER}")
  end

  it 'can navigate to the title summary from the address string search' do
    session.click_link($SMOKE_PARTIAL_ADDRESS)
    session.assert_text("Summary of title #{$SMOKE_TITLE_NUMBER}")
  end
end
