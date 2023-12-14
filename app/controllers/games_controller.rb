require 'httparty'

class GamesController < ApplicationController
    def new
        @letters = generate_random_letters(10)
    end
  
    def score
      @word = params["word"].upcase
      @grid = params["grid"].split(",")
  
      if !word_in_grid?(@word, @grid)
        @result = "The word can't be created from the original grid."
      elsif !english_word?(@word)
        @result = "The word is valid according to the grid, but it's not an English word."
      else
        @result = "Congratulations! The word is valid according to the grid and is an English word."
      end
    end
  
    private
    
    def generate_random_letters(number)
      alphabet = ('A'..'Z').to_a
      Array.new(number) { alphabet.sample }
    end
  
    def word_in_grid?(word, grid)
      word.chars.all? { |letter| word.count(letter) <= grid.count(letter) }
    end
  
    def english_word?(word)
      response = HTTParty.get("https://wagon-dictionary.herokuapp.com/#{word}")
      json_response = JSON.parse(response.body)
      json_response["found"]
    end
  end
  