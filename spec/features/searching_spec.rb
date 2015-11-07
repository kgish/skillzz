require "rails_helper"

RSpec.feature "Users can search for skills matching specific criteria" do

  let(:user) { FactoryGirl.create(:user) }
  let(:category) { FactoryGirl.create(:category) }
  let!(:skill_1) do
    FactoryGirl.create(:skill, name: "Create categories",
      category: category, author: user, tag_names: "iteration_1")
  end
  let!(:skill_2) do
    FactoryGirl.create(:skill, name: "Create users",
      category: category, author: user, tag_names: "iteration_2")
  end

  before do
    assign_role!(user, :manager, category)
    login_as(user)
    visit category_path(category)
  end

  scenario "searching by tag" do
    fill_in "Search", with: "tag:iteration_1"
    click_button "Search"
    within("#skills") do
      expect(page).to have_link "Create categories"
      expect(page).to_not have_link "Create users"
    end
  end

  scenario "when clicking on a tag" do
    click_link "Create categories"
    click_link "iteration_1"
    within("#skills") do
      expect(page).to have_content "Create categories"
      expect(page).to_not have_content "Create users"
    end
  end

end
