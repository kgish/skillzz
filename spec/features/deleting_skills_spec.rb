require "rails_helper"

RSpec.feature "Users can delete skills" do
  let(:category) { FactoryGirl.create(:category) }
  let(:skill) { FactoryGirl.create(:skill, category: category) }

  before do
    visit category_skill_path(category, skill)
  end

  scenario "successfully" do
    click_link "Delete Skill"

    expect(page).to have_content "Skill has been deleted."
    expect(page.current_url).to eq category_url(category)
  end
end