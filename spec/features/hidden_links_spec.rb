require "rails_helper"

RSpec.feature "Users can only see the appropriate links" do
  let(:category) { FactoryGirl.create(:category) }
  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:user, :admin) }
  let(:skill) do
    FactoryGirl.create(:skill, category: category, author: user)
  end

  context "anonymous users" do
    scenario "cannot see the New Category link" do
      visit categories_path
      expect(page).not_to have_link "New Category"
    end

    scenario "cannot see the Delete Category link" do
      visit categories_path
      expect(page).not_to have_link "Delete Category"
    end
  end

  context "non-admin users (category viewers)" do
    before do
      login_as(user)
      assign_role!(user, :viewer, category)
    end

    scenario "cannot see the New Category link" do
      visit categories_path
      expect(page).not_to have_link "New Category"
    end

    scenario "cannot see the Delete Category link" do
      visit category_path(category)
      expect(page).not_to have_link "Delete Category"
    end

    scenario "cannot see the Edit Category link" do
      visit category_path(category)
      expect(page).not_to have_link "Edit Category"
    end

    scenario "cannot see the Edit Skill link" do
      visit category_skill_path(category, skill)
      expect(page).not_to have_link "Edit Skill"
    end

    scenario "cannot see the Delete Skill link" do
      visit category_skill_path(category, skill)
      expect(page).not_to have_link "Delete Skill"
    end
  end

  context "admin users" do
    before { login_as(admin) }

    scenario "can see the New Category link" do
      visit categories_path
      expect(page).to have_link "New Category"
    end

    scenario "can see the Delete Category link" do
      visit category_path(category)
      expect(page).to have_link "Delete Category"
    end

    scenario "can see the Edit Category link" do
      visit category_path(category)
      expect(page).to have_link "Edit Category"
    end

    scenario "can see the Edit Skill link" do
      visit category_skill_path(category, skill)
      expect(page).to have_link "Edit Skill"
    end

    scenario "can see the Delete Skill link" do
      visit category_skill_path(category, skill)
      expect(page).to have_link "Delete Skill"
    end
  end
end