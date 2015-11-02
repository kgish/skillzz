require "rails_helper"

RSpec.feature "Users can delete categories" do
  scenario "successfully" do
    FactoryGirl.create(:category, name: "Programming")

    visit categories_url
    click_link "Programming"
    click_link "Delete Category"

    expect(page).to have_content "Category has been deleted."
    expect(page.current_url).to eq categories_url
    expect(page).to have_no_content "Programming"
  end
end