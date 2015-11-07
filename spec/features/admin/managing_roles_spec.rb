require "rails_helper"

RSpec.feature "Admins can manage a user's roles" do

  let(:admin) { FactoryGirl.create(:user, :admin) }
  let(:user) { FactoryGirl.create(:user) }
  let!(:category98) { FactoryGirl.create(:category, name: "Category #98") }
  let!(:category99) { FactoryGirl.create(:category, name: "Category #99") }

  before do
    login_as(admin)
  end

  scenario "when assigning roles to an existing user" do
    visit admin_user_path(user)
    click_link "Edit User"
    select "Viewer", from: "Category #98"
    select "Manager", from: "Category #99"
    click_button "Update User"
    expect(page).to have_content "User has been updated"
    click_link user.email
    expect(page).to have_content "Category #98: Viewer"
    expect(page).to have_content "Category #99: Manager"
  end

  scenario "when assigning roles to a new user" do
    visit new_admin_user_path
    fill_in "Username", with: "newbie"
    fill_in "Email", with: "newbie@skillzz.com"
    fill_in "Password", with: "password"
    select "Editor", from: "Category #98"
    click_button "Create User"
    click_link "newbie@skillzz.com"
    expect(page).to have_content "Category #98: Editor"
    expect(page).not_to have_content "Category #99"
  end

end