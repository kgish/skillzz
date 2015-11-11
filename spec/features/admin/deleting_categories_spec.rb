require "rails_helper"
require "faker"

RSpec.feature "Users can delete categories" do

  before do
    login_as(FactoryGirl.create(:user, :admin))
  end

  scenario "successfully" do
    category_name = Faker::Hipster.word
    FactoryGirl.create(:category, name: category_name)

    visit categories_url
    click_link category_name
    click_link "Delete Category"

    expect(page).to have_content "Category has been deleted."
    expect(page.current_url).to eq categories_url
    expect(page).to have_no_content category_name
  end
end