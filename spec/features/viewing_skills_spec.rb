require "rails_helper"

RSpec.feature "Users can view skills" do
  before do
    programming = FactoryGirl.create(:category, name: "Programming")
    FactoryGirl.create(:skill, category: programming,
      name: "Ruby",
      description: "Modern object-oriented language")

    cooking = FactoryGirl.create(:category, name: "Cooking")
    FactoryGirl.create(:skill, category: cooking,
      name: "BBQ",
      description: "American-style barbeque")
    visit "/"
  end

  scenario "for a given category" do
    click_link "Programming"
     expect(page).to have_content "Ruby"
     expect(page).to_not have_content "Modern object-oriented language"
     click_link "Ruby"
     within("#skill h2") do
       expect(page).to have_content "Ruby"
     end
     expect(page).to have_content "Modern object-oriented language"
  end
end

# TODO
# RSpec.feature "Users can view skills" do
#   scenario "with the skill details" do
#     skill = FactoryGirl.create(:skill, name: "Elixir", description: "Modern functional programming language")
#     visit skills_url
#     click_link "Elixir"
#     expect(page.current_url).to eq skill_url(skill)
#   end
# end