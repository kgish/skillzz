require 'rails_helper'

RSpec.feature 'Users can create new skills' do
  scenario 'with valid attributes' do
    visit '/'
    click_link 'New Skill'
    fill_in 'Name', with: 'Cooking'
    click_button 'Create Skill'
    expect(page).to have_content 'Skill has been created.'
  end
end