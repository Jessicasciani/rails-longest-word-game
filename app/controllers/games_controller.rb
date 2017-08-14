class GamesController < ApplicationController

  def game
    @alphabet = ("A".."Z").to_a
    @letters = []
    @start_time = Time.now
    8.times do
      @letters << @alphabet.sample
    end
  end


  def score

    @letters = params[:letters]
    @start_time = Time.parse(params[:start_time])
    @word = params[:word].upcase
    @end_time = Time.now

    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    serialized_file = open(url).read
    words = JSON.parse(serialized_file)

    @result = {
      time: (@end_time - @start_time),
      score: 0,
      message: ""
    }

    if included?(@word, @letters)
      if words["found"] == true
        @result[:score] += (((words["length"])/@result[:time])*100000).round
        @result[:message] = "Well done"
      else
        @result[:message] = "Not an english word"
      end
    else
      @result[:message] = "Not in the grid"
    end
  end

  private

  def included?(word, letters)
    word.chars.all? {|letter| word.count(letter) <= letters.count(letter)}
    #pour chaque lettre je fais "lettre" et je verifie que le nombre de chaque lettrz dans mon mot est inferieir ou egal a la grille
  end
end

