require "json"
require "open-uri"

class GamesController < ApplicationController
  LETTERS = ('a'..'z').to_a
  RANDOM_LETTERS = Array.new(10) { LETTERS.sample }
  def new
    @random_letters = RANDOM_LETTERS
  end

  def score
    user_input = params[:word_answer]
    url = "https://dictionary.lewagon.com/#{user_input}"
    user_serialized = URI.parse(url).read
    user = JSON.parse(user_serialized)

    @verify_api = user["found"]

    @random_letters = RANDOM_LETTERS
    @input_user_arr = user_input.split('')

    @verify = @input_user_arr.all? do |letter|
      @random_letters.include?(letter)
    end

    if !@verify
      @result = "Sorry but #{user_input.upcase} can't be built out of #{@random_letters.join(', ').upcase}"
    elsif !@verify_api
      @result = "Sorry but #{user_input.upcase} does not seem to be a valid English word..."
    else
      @result = "Congratulations! #{user_input.upcase} is a valid English word!"
    end
  end
end
