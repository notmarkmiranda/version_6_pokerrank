FactoryGirl.define do
  factory :game do
    date "2017-11-27"
    buy_in 100
    completed false
    season
    attendees 10

    factory :game_with_first_and_second do
      after(:create) do |game|
				[1, 2].each { |n| create(:player, game: game, finishing_place: n) }
      end
    end
  end
end
