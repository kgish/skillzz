require "rails_helper"

RSpec.feature "Users can sign in" do
  let!(:user) { FactoryGirl.create(:user) }

  scenario "with valid credentials (email)" do
    visit "/"
    click_link "Sign in"
    fill_in "Username or email", with: user.email
    fill_in "Password", with: "password"
    click_button "Sign in"

    expect(page).to have_content "Signed in successfully."
    expect(page).to have_content "Signed in as #{user.username}"
  end

  scenario "with valid credentials (username)" do
    visit "/"
    click_link "Sign in"
    fill_in "Username or email", with: user.username
    fill_in "Password", with: "password"
    click_button "Sign in"

    expect(page).to have_content "Signed in successfully."
    expect(page).to have_content "Signed in as #{user.username}"
  end

  scenario "unless they are archived" do
    user.archive
    visit "/"
    click_link "Sign in"
    fill_in "Username or email", with: user.email
    fill_in "Password", with: "password"
    click_button "Sign in"

    expect(page).to have_content "Your account has been archived."
  end

end