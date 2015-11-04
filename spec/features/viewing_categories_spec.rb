require "rails_helper"

RSpec.feature "Users can view categories" do
  scenario "with the category details" do
    category = FactoryGirl.create(:category, name: "Programming")
    visit categories_url
    click_link "Programming"

    expect(page.current_url).to eq category_url(category)
  end
end