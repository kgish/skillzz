require "rails_helper"

RSpec.feature "Users can edit existing skills" do
  let(:author) { FactoryGirl.create(:user) }
  let(:category) { FactoryGirl.create(:category) }
  let(:skill) do
    FactoryGirl.create(:skill, category: category, author: author)
  end

  before do
    visit category_skill_path(category, skill)
    click_link "Edit Skill"
  end


  scenario "with valid attributes" do
    fill_in "Name", with: "JavaScript"
    click_button "Update Skill"

    expect(page).to have_content "Skill has been updated."

    within("#skill h2") do
      expect(page).to have_content "JavaScript"
      expect(page).not_to have_content skill.name
    end
  end

  scenario "with invalid attributes" do
    fill_in "Name", with: ""

    click_button "Update Skill"
    expect(page).to have_content "Skill has not been updated."
  end

  # TODO:
  # before do
  #   FactoryGirl.create(:skill, name: "Fortran", description: "Imperative programming language for scientific computing")
  #
  #   visit skills_url
  #   click_link "Fortran"
  #   click_link "Edit Skill"
  # end
  #
  # scenario "with valid attributes" do
  #   fill_in "Name", with: "Pascal"
  #   click_button "Update Skill"
  #
  #   expect(page).to have_content "Skill has been updated."
  #   expect(page).to have_content "Pascal"
  # end
  #
  # scenario "when providing invalid attributes" do
  #   fill_in "Name", with: ""
  #   click_button "Update Skill"
  #   expect(page).to have_content "Skill has not been updated."
  #   expect(page).to have_content "Name can't be blank"
  # end

end