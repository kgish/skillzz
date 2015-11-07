require "rails_helper"

RSpec.feature "Users can delete unwanted tags from a skill" do
  let(:user) { FactoryGirl.create(:user) }
  let(:category) { FactoryGirl.create(:category) }
  let(:skill) do
    FactoryGirl.create(:skill, category: category,
    tag_names: "killme", author: user)
  end

  before do
    login_as(user)
    assign_role!(user, :manager, category)
    visit category_skill_path(category, skill)
  end

  scenario "successfully", js: true do
    within tag("killme") do
      click_link "remove"
    end
    expect(page).to_not have_content "killme"
  end
end