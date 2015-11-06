require 'rails_helper'

RSpec.describe SkillsController, type: :controller do

  let(:category) { FactoryGirl.create(:category) }
  let(:user) { FactoryGirl.create(:user) }

  before :each do
    assign_role!(user, :editor, category)
    sign_in user
  end

  it "can create skills, but not tag them" do
    post :create,
         skill: {
             name: "Another amazing skill",
             description: "Hard to believe but true",
             tag_names: "these are tags"
         },
         category_id: category.id
    expect(Skill.last.tags).to be_empty
  end

  # TODO
  # it "handles a missing skill correctly" do
  #   get :show, id: "not-here"
  #   expect(response).to redirect_to(categories_path)
  #   message = "The skill you were looking for could not be found."
  #   expect(flash[:alert]).to eq message
  # end

end
