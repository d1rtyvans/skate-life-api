require 'rails_helper'

RSpec.describe 'POST /favorites' do
  it 'should create a favorite for corresponding park and user' do
    user = create(:user)
    skatepark = create(:skatepark)

    expect do
      post '/favorites', user_id: user.id, skatepark_id: skatepark.id
    end.to change { user.skateparks.count }.by(1)

    fav = Favorite.where(user_id: user.id, skatepark_id: skatepark.id).first

    expect(fav.user).to eq(user)
    expect(fav.skatepark).to eq(skatepark)
  end

  it 'should return 400 if favorite already exists' do
    user = create(:user)
    skatepark = create(:skatepark)
    user.skateparks << skatepark

    expect do
      post '/favorites', user_id: user.id, skatepark_id: skatepark.id
    end.to_not change { user.skateparks.count }
    expect(response.status).to eq(400)
  end

  it 'should return 400 if skatepark or user does not exist' do
    user = create(:user)
    skatepark = create(:skatepark)

    expect do
      post '/favorites', user_id: user.id, skatepark_id: 5
    end.to_not change { user.skateparks.count }
    expect(response.status).to eq(400)

    expect do
      post '/favorites', user_id: 1, skatepark_id: skatepark.id
    end.to_not change { user.skateparks.count }
    expect(response.status).to eq(400)
  end
end

RSpec.describe 'DELETE /favorites' do
  it "should remove park from user's favorites" do
    user = create(:user)
    skatepark = create(:skatepark)
    user.skateparks << skatepark

    expect do
      delete "/favorite/#{user.id}/#{skatepark.id}"
    end.to change { user.skateparks.count }.by(-1)
    expect(response.status).to eq(204)
  end

  it 'should return 400 if user has not favorited park' do
    user = create(:user)

    expect do
      delete "/favorite/#{user.id}/420"
    end.to_not change { user.skateparks.count }
    expect(response.status).to eq(400)
  end
end
