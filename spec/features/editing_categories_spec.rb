require "rails_helper"

RSpec.feature "Users can edit existing categories" do
  let(:user) { FactoryGirl.create(:user) }
  let(:category) { FactoryGirl.create(:category, name: "Technical Tooling") }

  before do
    login_as(user)
    assign_role!(user, :viewer, category)
    visit categories_url
    click_link "Technical Tooling"
    click_link "Edit Category"
  end

  scenario "with valid attributes" do
    fill_in "Name", with: "Git"
    click_button "Update Category"

    expect(page).to have_content "Category has been updated."
    expect(page).to have_content "Git"
  end

  scenario "when providing invalid attributes" do
    fill_in "Name", with: ""
    click_button "Update Category"

    expect(page).to have_content "Category has not been updated."
    expect(page).to have_content "Name can't be blank"
  end

end