require "rails_helper"

RSpec.feature "Users can create new skills" do
  let(:user) { FactoryGirl.create(:user) }

  before do
    login_as(user)
    category = FactoryGirl.create(:category, name: "Programming", description: "Wonderful world of software development")
    assign_role!(user, :editor, category)
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

# TODO: extend above test with the stuff below.
#
# RSpec.feature "Users can create new skills" do
#
#   before do
#     visit skills_url
#     click_link "New Skill"
#   end
#
#   scenario "with valid attributes" do
#     fill_in "Name", with: "Ruby"
#     fill_in "Description", with: "Modern object-oriented language"
#     click_button "Create Skill"
#     expect(page).to have_content "Ruby"
#     expect(page).to have_content "Modern object-oriented language"
#
#     skill = Skill.find_by(name: "Ruby")
#     expect(page.current_url).to eq skill_url(skill)
#     title = "Ruby - Skills - SkillZZ"
#     expect(page).to have_title title
#   end
#
#   scenario "when providing invalid attributes (blank name)" do
#     fill_in "Name", with: ""
#     fill_in "Description", with: "Modern object-oriented language"
#     click_button "Create Skill"
#     expect(page).to have_content "Skill has not been created."
#     expect(page).to have_content "Name can't be blank"
#   end
#
#   scenario "when providing invalid attributes (blank description)" do
#     fill_in "Name", with: "Ruby"
#     fill_in "Description", with: ""
#     click_button "Create Skill"
#     expect(page).to have_content "Skill has not been created."
#     expect(page).to have_content "Description can't be blank"
#   end
#
#   scenario "when providing invalid attributes (non-unique name)" do
#     fill_in "Name", with: "Ruby"
#     fill_in "Description", with: "Modern object-oriented language"
#     click_button "Create Skill"
#     expect(page).to have_content "Ruby"
#
#     visit skills_url
#     click_link "New Skill"
#     fill_in "Name", with: "Ruby"
#     fill_in "Description", with: "Modern object-oriented language"
#     click_button "Create Skill"
#     expect(page).to have_content "Skill has not been created."
#     expect(page).to have_content "Name has already been taken"
#   end
# end