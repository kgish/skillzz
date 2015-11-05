require 'spec_helper'

describe CategoryPolicy do

  let(:user) { User.new }

  subject { CategoryPolicy }

  context "policy_scope" do
    subject { Pundit.policy_scope(user, Category) }

    let!(:category) { FactoryGirl.create :category }
    let(:user) { FactoryGirl.create :user }

    it "is empty for anonymous users" do
      expect(Pundit.policy_scope(nil, Category)).to be_empty
    end

    it "includes categories a user is allowed to view" do
      assign_role!(user, :viewer, category)
      expect(subject).to include(category)
    end

    it "doesn't include categories a user is not allowed to view" do
      expect(subject).to be_empty
    end

    it "returns all categories for admins" do
      user.admin = true
      expect(subject).to include(category)
    end
  end

  permissions :show? do
    let(:user) { FactoryGirl.create :user }
    let(:category) { FactoryGirl.create :category }

    it "blocks anonymous users" do
      expect(subject).not_to permit(nil, category)
    end

    it "allows viewers of the category" do
      assign_role!(user, :viewer, category)
      expect(subject).to permit(user, category)
    end

    it "allows editors of the category" do
      assign_role!(user, :editor, category)
      expect(subject).to permit(user, category)
    end

    it "allows managers of the category" do
      assign_role!(user, :manager, category)
      expect(subject).to permit(user, category)
    end

    it "allows administrators" do
      admin = FactoryGirl.create :user, :admin
      expect(subject).to permit(admin, category)
    end

    it "doesn't allow users assigned to other categories" do
      other_category = FactoryGirl.create(:category, name: "Other category")
      assign_role!(user, :manager, other_category)
      expect(subject).not_to permit(user, category)
    end
  end

  permissions :update? do
    let(:user) { FactoryGirl.create :user }
    let(:category) { FactoryGirl.create :category }

    it "blocks anonymous users" do
      expect(subject).not_to permit(nil, category)
    end

    it "doesn't allow viewers of the category" do
      assign_role!(user, :viewer, category)
      expect(subject).not_to permit(user, category)
    end

    it "doesn't allows editors of the category" do
      assign_role!(user, :editor, category)
      expect(subject).not_to permit(user, category)
    end

    it "allows managers of the category" do
      assign_role!(user, :manager, category)
        expect(subject).to permit(user, category)
    end

    it "allows administrators" do
      admin = FactoryGirl.create :user, :admin
      expect(subject).to permit(admin, category)
    end

    it "doesn't allow users assigned to other categories" do
      other_category = FactoryGirl.create(:category, name: "Other category")
      assign_role!(user, :manager, other_category)
      expect(subject).not_to permit(user, category)
    end
  end

end
