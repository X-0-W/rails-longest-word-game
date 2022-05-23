require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @grid = []
    10.times do
      @grid << ('A'..'Z').to_a.sample
    end
  end

  def score
    @word_exists = api_check
    @in_grid = check_attempt(params[:answer], params[:grid])
  end

  private

  def api_check
    # check whether given word matches api
    url = "https://wagon-dictionary.herokuapp.com/#{params[:answer]}"
    attempt_check = URI.open(url).read
    api_output = JSON.parse(attempt_check)
    api_output['found']
  end

  def check_attempt(attempt, grid)
    grid_values = grid.gsub(/\s+/, '').split
    grid_hash = grid_values.tally
    attempt_hash = attempt.upcase.chars.tally
    i = 0
    attempt_hash.each do |key, _|
      grid_hash.key?(key) && attempt_hash[key] <= grid_hash[key] ? i += 0 : i += 1
    end
    i.zero?
  end

  # def points(attempt, start_time, end_time)
  #   time_taken = end_time - start_time
  #   (attempt.length**2) + [30 - time_taken, 0].max
  # end
end
