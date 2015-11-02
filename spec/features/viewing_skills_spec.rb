require "rails_helper"

RSpec.feature "Users can view skills" do
  scenario "with the skill details" do
    skill = FactoryGirl.create(:skill, name: "Elixir")
    visit skills_url
    click_link "Elixir"
    expect(page.current_url).to eq skill_url(skill)
  end
end