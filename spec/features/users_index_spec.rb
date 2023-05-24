# rubocop:disable Metrics/BlockLength
require 'rails_helper'

RSpec.feature 'Users', type: :feature do
  before(:each) do
    @user1 = FactoryBot.create(:user, name: 'Jacob', photo: 'https://i.pravatar.cc/300?img=1', bio: 'I am Jacob')
    @user2 = FactoryBot.create(:user, name: 'Kelvin', photo: 'https://i.pravatar.cc/300?img=2', bio: 'I am Kelvin')
    @user3 = FactoryBot.create(:user, name: 'Andrew', photo: 'https://i.pravatar.cc/300?img=3', bio: 'I am Andrew')
    FactoryBot.create(:post, author: @user1)
    FactoryBot.create(:post, author: @user2)
    FactoryBot.create(:post, author: @user3)
  end

  describe 'Users Index' do
    scenario 'I can see the usernames of all other users' do
      visit root_path
      expect(page).to have_content(@user1.name)
      expect(page).to have_content(@user2.name)
      expect(page).to have_content(@user3.name)
    end

    scenario 'I can see the profile picture of all other users' do
      visit root_path
      expect(page).to have_selector("img[src='https://i.pravatar.cc/300?img=1']")
      expect(page).to have_selector("img[src='https://i.pravatar.cc/300?img=2']")
      expect(page).to have_selector("img[src='https://i.pravatar.cc/300?img=3']")
    end

    scenario 'I can see the number of posts of all other users' do
      visit root_path
      expect(page).to have_content(@user1.posts_counter)
      expect(page).to have_content(@user2.posts_counter)
      expect(page).to have_content(@user3.posts_counter)
    end

    scenario 'When i click on a username, I am taken to that user\'s profile page' do
      visit root_path
      click_link @user1.name
      sleep(5)
      expect(current_path).to eq(user_path(@user1.id))
    end

    scenario 'When i click on a user bio, I am taken to that user\'s profile page' do
      visit root_path
      click_link @user1.bio
      sleep(5)
      expect(current_path).to eq(user_path(@user1.id))
    end
  end

  describe 'User show page' do
    scenario 'I can see the user profile picture' do
      visit user_path(@user1.id)
      expect(page).to have_selector("img[src='https://i.pravatar.cc/300?img=1']")
    end

    scenario 'I can see the user name' do
      visit user_path(@user1.id)
      expect(page).to have_content(@user1.name)
    end

    scenario 'I can see the number of posts of the user' do
      visit user_path(@user1.id)
      expect page.has_content?(@user1.posts_counter)
    end

    scenario 'I can see the user bio' do
      visit user_path(@user3.id)
      expect(page).to have_content(@user3.bio)
    end

    scenario 'I can see a button that lets me view all of the user\'s posts' do
      visit user_path(@user3.id)
      expect page.has_link?('See all Posts')
    end

    scenario 'When I click on the button, I am redirected to the user\'s posts index page' do
      visit user_path(@user3)
      within '.btn_container' do
        click_link 'See all Posts'
      end
      expect(page).to have_current_path(user_posts_path(@user3))
    end

    scenario 'When I click on a post, I am taken to that post\'s show page' do
      visit user_posts_path(@user1)
      click_link @user1.posts.first.title
      expect(page).to have_current_path(user_post_path(@user1, @user1.posts.first))
    end
  end
end
# rubocop:enable Metrics/BlockLength
