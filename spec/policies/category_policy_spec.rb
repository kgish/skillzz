require 'spec_helper'

describe CategoryPolicy do

  let(:user) { User.new }

  subject { CategoryPolicy }

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
      other_category = FactoryGirl.create :category
      assign_role!(user, :manager, other_category)
      expect(subject).not_to permit(user, category)
    end
  end
end
