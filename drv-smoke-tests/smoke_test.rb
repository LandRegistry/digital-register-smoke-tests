require 'capybara/poltergeist'
session = Capybara::Session.new(:poltergeist)

session.visit "#{$DIGITAL_REGISTER_URL}"
begin
  session.has_content?("Login")
rescue
  puts "Login page unavailable"
end
begin
  fill_in 'username', with: $SMOKE_USERNAME
  fill_in 'password', with: $SMOKE_PASSWORD
  click_button('signin')
rescue
  puts "Unable to login"
end
