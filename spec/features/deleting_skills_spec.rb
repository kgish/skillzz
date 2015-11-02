require "rails_helper"

RSpec.feature "Users can delete skills" do
  scenario "successfully" do
    FactoryGirl.create(:skill, name: "Fortran")

    visit skills_url
    click_link "Fortran"
    click_link "Delete Skill"

    expect(page).to have_content "Skill has been deleted."
    expect(page.current_url).to eq skills_url
    expect(page).to have_no_content "Fortran"
  end
end