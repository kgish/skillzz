require "rails_helper"

RSpec.feature "Signed-in users can sign out" do
  let!(:user) { FactoryGirl.create(:user) }

  before do
    login_as(user)
  end

  scenario "by going to the homepage and clicking on the sign out link" do
    visit "/"
    click_link "Sign out"
    expect(page).to have_content "Signed out successfully."
  end
end