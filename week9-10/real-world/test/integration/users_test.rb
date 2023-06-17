require 'test_helper'

class UsersTest < ActionDispatch::IntegrationTest
  test 'should register new user with valid data' do
    user_attributes = attributes_for(:user)
    assert_difference 'User.count', 1 do
      post '/api/users', params: { user: user_attributes }
    end

    json_response = JSON.parse(@response.body)
    assert_equal user_attributes[:email], json_response['user']['email']
    assert_equal user_attributes[:username], json_response['user']['username']
    assert_not_nil json_response['user']['token']

    assert_response 201
  end

  test 'should not create user with invalid or duplicate email' do
    create(:user, email: 'duplicate@example.com')

    post '/api/users', params: {
      user: {
        email: 'duplicate@example.com',
        username: Faker::Internet.username,
        password: Faker::Internet.password
      }
    }
    assert_response :unprocessable_entity
    assert_match(/errors/, response.body)
  end

  test 'should not create user with invalid or duplicate username' do
    create(:user, username: 'duplicateusername')

    post '/api/users', params: {
      user: {
        email: Faker::Internet.email,
        username: 'duplicateusername',
        password: Faker::Internet.password
      }
    }
    assert_response :unprocessable_entity
    assert_match(/errors/, response.body)
  end

  test 'should not create user with missing parameters' do
    post '/api/users', params: {
      user: {
        email: Faker::Internet.email,
        password: Faker::Internet.password
      }
    }
    assert_response :unprocessable_entity
    assert_match(/errors/, response.body)
  end
end
