Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/start",to: "game#game_welcome"
  get "/game",to: "game#launch_game"
  get "/score",to: "game#score"

end
