require 'open-uri'
require 'json'
require 'date'

class GameController < ApplicationController

  def game_welcome
  end

  def launch_game
    @grid_size = params[:size].to_i
    @grid = generate_grid(@grid_size)
    @start_time = params[:time]
  end

  def generate_grid(grid_size)
    grid = []
    n = grid_size / 2
    n.times do
      grid.push(["A", "E", "I", "O", "U", "Y"].sample)
    end
    consol_grid = ("A".."Z").to_a.reject { |voyel| ["A", "E", "I", "O", "U", "Y"].include?(voyel) }
    (grid_size - n).times do
      grid.push(consol_grid.to_a.sample)
    end
    return grid.shuffle
  end

  def score
    @attempt = params[:answer]
    @start_time = Time.parse(params[:start_time])
    @end_time = Time.now
    @grid= params[:grid].split("")
    result = run_game(@attempt, @grid, @start_time, @end_time)
    @time = result[:time].round(1)
    @score = result[:score].round(2)
    @message = result[:message]
  end

  def run_game(attempt, grid, start_time, end_time)
    time = end_time - start_time
    result_api = { time: time, translation: " ", score: 0, message: "not in the grid" }
    return result_api if grid_include?(attempt, grid) == false
    url = "https://wagon-dictionary.herokuapp.com/#{attempt.downcase}"
    result_api = JSON.parse(open(url).read)
    return result(result_api, time)
  end

  def result(result_api, time)
    result = { time: time, translation: " ", score: 0, message: "not an english word" }
    return result if result_api["found"] == false
    intermediary_res = result_api["length"] - time / 10
    intermediary_res > 0 ? result[:score] = intermediary_res : result[:score] = 0
    result[:message] = "Well done"
    return result
  end

  def grid_include?(attempt, grid)
    attempt.upcase.split("").each do |item|
      if grid.include?(item)
        grid.delete_at(grid.index(item))
      else
        return false
      end
    end
    return true
  end


end
