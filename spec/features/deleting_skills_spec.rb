require "rails_helper"

RSpec.feature "Users can delete skills" do
  let(:author) { FactoryGirl.create(:user) }
  let(:category) { FactoryGirl.create(:category) }
  let(:skill) do
    FactoryGirl.create(:skill, category: category, author: author)
  end

  before do
    login_as(author)
    assign_role!(author, :manager, category)
    visit category_skill_path(category, skill)
  end

  scenario "successfully" do
    click_link "Delete Skill"

    expect(page).to have_content "Skill has been deleted."
    expect(page.current_url).to eq category_url(category)
  end
end