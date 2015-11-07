require "rails_helper"
require "faker"

RSpec.feature "Users can sign up" do
  scenario "when providing valid details" do
    visit "/"
    click_link "Sign up"
    # TODO
    fill_in "Username", with: Faker::Internet.user_name
    fill_in "Email", with: Faker::Internet.email
    fill_in "user_password", with: "password"
    fill_in "Password confirmation", with: "password"
    click_button "Sign up"

    expect(page).to have_content("You have signed up successfully.")
  end
end