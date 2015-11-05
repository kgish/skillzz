require "rails_helper"

RSpec.feature "Users can view categories" do
  let(:user) { FactoryGirl.create(:user) }
  let(:category) { FactoryGirl.create(:category, name: "Programming") }

  before do
    login_as(user)
    assign_role!(user, :viewer, category)
  end

  scenario "with the category details" do
    visit categories_url
    click_link "Programming"

    expect(page.current_url).to eq category_url(category)
  end
end
