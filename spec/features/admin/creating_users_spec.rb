require "rails_helper"
require "faker"

RSpec.feature "Admins can create new users" do
  let(:admin) { FactoryGirl.create(:user, :admin) }

  before do
    login_as(admin)
    visit "/"
    click_link "Admin"
    click_link "Users"
    click_link "New User"
  end

  scenario "with valid credentials" do
    fill_in "Username", with: "newbie"
    fill_in "Email", with: "newbie@skillzz.com"
    fill_in "Password", with: "newbie12345"
    click_button "Create User"

    expect(page).to have_content "User has been created."
  end

  scenario "when the new user is an admin" do
    fill_in "Username", with: "admin"
    fill_in "Email", with: "admin2@skillzz.com"
    fill_in "Password", with: "password"
    check "Is an admin?"
    click_button "Create User"

    expect(page).to have_content "User has been created."
    expect(page).to have_content "admin2@skillzz.com (Admin)"
  end

end