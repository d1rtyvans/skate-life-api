require 'rails_helper'

RSpec.describe 'GET /users' do
  it 'should return a list of all users' do
    user = create(:user)
    other = create(:user, :other)

    get '/users'

    expect(json_body.count).to eq(2)
    expect(json_body[0]['id']).to eq(user.id)
    expect(json_body[0]['email']).to eq(user.email)
    expect(json_body[0]['name']).to eq(user.name)
    expect(json_body[1]['id']).to eq(other.id)
    expect(json_body[1]['name']).to eq(other.name)
  end
end

RSpec.describe 'GET /users/:id' do
  it 'should return user with the corresponding :id' do
    user = create(:user)

    get "/users/#{user.id}"

    expect(json_body['id']).to eq(user.id)
    expect(json_body['name']).to eq(user.name)
    expect(json_body['email']).to eq(user.email)
  end

  it 'should return 404 if user cannot be found' do
    expected_response = { 'error' => 'User Not Found' }

    get '/users/420'

    expect(json_body).to eq(expected_response)
    expect(response.status).to eq(404)
  end
end

RSpec.describe 'POST /users' do
  it 'should create and return a user' do
    user = build(:user)

    expect do
      post '/users', user: user.to_json
    end.to change { User.count }.by(1)
    expect(json_body['name']).to eq(user.name)
    expect(json_body['email']).to eq(user.email)
  end

  it 'should return 400 if user cannot be created' do
    expected_response = { 'error' => 'Email cannot be blank' }
    user = build(:user, :invalid)

    expect do
      post '/users', user: user.to_json
    end.to_not change { User.count }
    expect(json_body).to eq(expected_response)
    expect(response.status).to eq(400)
  end
end

RSpec.describe 'DELETE /users' do
  it 'should destroy user with the corresponding :id' do
    user = create(:user)

    expect do
      delete "/users/#{user.id}"
    end.to change { User.count }.by(-1)
    expect(response.status).to eq(204)
  end

  it 'should return 400 if user does not exist' do
    expected_response = { 'error' => 'User Not Found' }

    expect do
      delete '/users/420'
    end.to_not change { User.count }
    expect(json_body).to eq(expected_response)
    expect(response.status).to eq(400)
  end
end
