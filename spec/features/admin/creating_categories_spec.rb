require "rails_helper"

RSpec.feature "Users can create new categories" do

  before do
    login_as(FactoryGirl.create(:user, :admin))
    visit categories_url
    click_link "New Category"
  end

  scenario "with valid attributes" do
    fill_in "Name", with: "Programming"
    fill_in "Description", with: "Anything to do with software development"
    click_button "Create Category"
    expect(page).to have_content "Programming"

    category = Category.find_by(name: "Programming")
    expect(page.current_url).to eq category_url(category)
    title = "Programming - Categories - SkillZZ"
    expect(page).to have_title title
  end

  scenario "when providing invalid attributes (blank name and description)" do
    click_button "Create Category"
    expect(page).to have_content "Category has not been created."
    expect(page).to have_content "Name can't be blank"
    expect(page).to have_content "Description can't be blank"
  end

  scenario "when providing invalid attributes (blank name)" do
    fill_in "Description", with: "Anything to do with software development"
    click_button "Create Category"
    expect(page).to have_content "Category has not been created."
    expect(page).to have_content "Name can't be blank"
  end

  scenario "when providing invalid attributes (blank description)" do
    fill_in "Name", with: "Programming"
    click_button "Create Category"
    expect(page).to have_content "Category has not been created."
    expect(page).to have_content "Description can't be blank"
  end

  scenario "when providing invalid attributes (non-unique name)" do
    fill_in "Name", with: "Programming"
    fill_in "Description", with: "Anything to do with software development"
    click_button "Create Category"
    expect(page).to have_content "Programming"

    visit categories_url
    click_link "New Category"
    fill_in "Name", with: "Programming"
    fill_in "Description", with: "This text doesn't really matter"
    click_button "Create Category"
    expect(page).to have_content "Category has not been created."
    expect(page).to have_content "Name has already been taken"
  end
end