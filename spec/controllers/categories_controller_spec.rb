require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do

  it "handles a missing category correctly" do
    get :show, id: "not-here"
    expect(response).to redirect_to(categories_path)
    message = "The category you were looking for could not be found."
    expect(flash[:alert]).to eq message
  end

end
