Given /^a user belonging to an existing centre$/ do
  @centre = Centre.create!(:name => "lyon", :code => "ly")
  @user = @centre.users.create!(
    :username => "username",
    :password => "password",
    :email => "myuser@example.com")
end

When /^the user logs in with correct credentials$/ do
  login(@user.username, @user.password)
end

When /^the user logs in with wrong credentials$/ do
  login("wronguser", "wrongpassword")
end

Given /^a centre admin is logged in$/ do
  steps %Q{
    Given a user belonging to an existing centre
    When the user logs in with correct credentials
  }
  @user.update_attribute(:role,"centre_admin")
end

When /should see a success message$/ do
  steps %Q{
    Then I should see a "devise.sessions.signed_in" message
  }
end

Then /^they should be denied access$/ do
  steps %Q{
    Then I should see a "devise.failure.invalid" message
  }
end
