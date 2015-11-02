require 'rails_helper'

RSpec.feature 'Users can create new skills' do

  before do
    visit '/'
    click_link 'New Skill'
  end


  scenario 'with valid attributes' do
    fill_in 'Name', with: 'Cooking'
    click_button 'Create Skill'
    expect(page).to have_content 'Cooking'

    skill = Skill.find_by(name: 'Cooking')
    expect(page.current_url).to eq skill_url(skill)
    title = 'Cooking - Skills - SkillZZ'
    expect(page).to have_title title
  end


  scenario 'when providing invalid attributes' do
    click_button 'Create Skill'
    expect(page).to have_content 'Skill has not been created.'
    expect(page).to have_content 'Name can\'t be blank'
  end

end