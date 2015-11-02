require "rails_helper"

RSpec.feature "Users can edit existing categories" do
  before do
    FactoryGirl.create(:category, name: "Household")

    visit categories_url
    click_link "Household"
    click_link "Edit Category"
  end

  scenario "with valid attributes" do
    fill_in "Name", with: "Household #2"
    click_button "Update Category"

    expect(page).to have_content "Category has been updated."
    expect(page).to have_content "Household #2"
  end

  scenario "when providing invalid attributes" do
    fill_in "Name", with: ""
    click_button "Update Category"
    expect(page).to have_content "Category has not been updated."
    expect(page).to have_content "Name can't be blank"
end

end