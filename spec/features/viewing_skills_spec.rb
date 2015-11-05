require "rails_helper"

RSpec.feature "Users can view skills" do
  before do
    author = FactoryGirl.create(:user)
    programming = FactoryGirl.create(:category, name: "Programming")
    assign_role!(author, :viewer, programming)
    FactoryGirl.create(:skill, category: programming,
      author: author,
      name: "Ruby",
      description: "Modern object-oriented language")

    cooking = FactoryGirl.create(:category, name: "Cooking")
    assign_role!(author, :viewer, cooking)
    FactoryGirl.create(:skill, category: cooking,
      name: "BBQ",
      author: author,
      description: "American-style barbeque")
    login_as(author)
    visit categories_path
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
