require_relative 'test_variables'
require 'capybara/poltergeist'
session = Capybara::Session.new(:poltergeist)

session.visit "#{$DIGITAL_REGISTER_URL}"

# Check that the login page is up
begin
  session.has_content?("Login")
rescue
  puts "Login page unavailable"
end
# Confirm that you can login with correct credentials
begin
  session.fill_in 'username', with: $SMOKE_USERNAME
  session.fill_in 'password', with: $SMOKE_PASSWORD
  session.click_button('signin')
  session.assert_text('Search for the title of any property in England and Wales')
rescue
  puts "Unable to login"
end
# Confirm that you can search with a title number
begin
  session.fill_in 'search_term', with: $SMOKE_TITLE_NUMBER
  session.click_button('Search')
  session.assert_text("#{$SMOKE_TITLE_NUMBER}")
rescue
  puts "Title number search has failed"
end
# Check that a title page is displayed
begin
  session.assert_text("Summary of title #{$SMOKE_TITLE_NUMBER}")
rescue
  puts "Title summary page has not displayed"
end
# Go back to search page
begin
  session.click_link('Find a title')
  session.assert_text('Search for the title of any property in England and Wales')
rescue
  puts "Unable to navigate to search page"
end
# Search with postcode
begin
  session.fill_in 'search_term', with: $SMOKE_POSTCODE
  session.click_button('Search')
  session.assert_text("#{$SMOKE_TITLE_NUMBER}")
rescue
  puts "Postcode search has failed"
end
# View a title that has been searched with via postcode
begin
  session.click_link($SMOKE_PARTIAL_ADDRESS)
  session.assert_text("Summary of title #{$SMOKE_TITLE_NUMBER}")
rescue
  puts "Unable to navigate to title summary from search page"
end
# Go back to search page
begin
  session.click_link('Find a title')
  session.assert_text('Search for the title of any property in England and Wales')
rescue
  puts "Unable to navigate to search page"
end
# Search with address string
begin
  session.fill_in 'search_term', with: $SMOKE_PARTIAL_ADDRESS
  session.click_button('Search')
  session.assert_text("#{$SMOKE_TITLE_NUMBER}")
rescue
  puts "Address string search has failed"
end
# View a title that has been searched with via postcode
begin
  session.click_link($SMOKE_PARTIAL_ADDRESS)
  session.assert_text("Summary of title #{$SMOKE_TITLE_NUMBER}")
rescue
  puts "Unable to navigate to title summary from search page"
end
