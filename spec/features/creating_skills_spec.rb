require "rails_helper"

RSpec.feature "Users can create new skills" do
  let(:user) { FactoryGirl.create(:user) }

  before do
    login_as(user)
    category = FactoryGirl.create(:category, name: "Programming", description: "Wonderful world of software development")
    assign_role!(user, :manager, category)

    visit category_path(category)
    click_link "New Skill"
  end

  scenario "with valid attributes" do
    fill_in "Name", with: "Ruby"
    fill_in "Description", with: "Modern object-oriented language"
    click_button "Create Skill"

    expect(page).to have_content "Skill has been created."
    within("#skill") do
      expect(page).to have_content "Author: #{user.email}"
    end
  end

  scenario "when providing invalid attributes" do
    click_button "Create Skill"

    expect(page).to have_content "Skill has not been created."
    expect(page).to have_content "Name can't be blank"
    expect(page).to have_content "Description can't be blank"
  end

  scenario "with an invalid description" do
    fill_in "Name", with: "C/C++"
    fill_in "Description", with: "Too short"
    click_button "Create Skill"

    expect(page).to have_content "Skill has not been created."
    expect(page).to have_content "Description is too short"
  end

  scenario "with associated tags" do
    fill_in "Name", with: "Fortran"
    fill_in "Description", with: "Old-fashioned scientific programming language"
    fill_in "Tags", with: "imperative numerical"
    click_button "Create Skill"

    expect(page).to have_content "Skill has been created."
    within("#skill #tags") do
       expect(page).to have_content "imperative"
       expect(page).to have_content "numerical"
    end
  end
end
