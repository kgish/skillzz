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

  context "permissions" do
    subject { CategoryPolicy.new(user, category) }
    let(:user) { FactoryGirl.create(:user) }
    let(:category) { FactoryGirl.create(:category) }

    context "for anonymous users" do
      let(:user) { nil }
      it { should_not permit_action :show }
      it { should_not permit_action :update }
    end

    context "for viewers of the category" do
      before { assign_role!(user, :viewer, category) }
      it { should permit_action :show }
      it { should_not permit_action :update }
    end

    context "for editors of the category" do
      before { assign_role!(user, :editor, category) }
      it { should permit_action :show }
      it { should_not permit_action :update }
    end

    context "for managers of the category" do
      before { assign_role!(user, :manager, category) }
      it { should permit_action :show }
      it { should permit_action :update }
    end

    context "for managers of other categories" do
      before do
        assign_role!(user, :manager, FactoryGirl.create(:category))
      end
      it { should_not permit_action :show }
      it { should_not permit_action :update }
    end

    context "for administrators" do
      let(:user) { FactoryGirl.create :user, :admin }
      it { should permit_action :show }
      it { should permit_action :update }
    end
  end

end
