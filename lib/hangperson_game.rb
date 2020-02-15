class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.
  attr_accessor :word
  attr_accessor :guesses
  attr_accessor :wrong_guesses
  # Get a word from remote "random word" service

  # def initialize()
  # end
  
  def initialize(word)
    @word = word
    @guesses = ""
    @wrong_guesses = ""
  end
  
  def guess(g)
    if g.nil? or g.length == 0 or !(g =~ /[[:alpha:]]/)
      raise ArgumentError.new("Not a valid character")
    end
    
    lower_case = g >= 'a' && g <= 'z'
    g.downcase!
    
    different = !(@guesses.include? g) && !(@wrong_guesses.include? g)
    valid = different && lower_case
    return false unless valid
    
    if word.include? g
      @guesses += g
    else
      @wrong_guesses += g
    end
    
    valid
  end
  
  def word_with_guesses
    guess_word = ''
    @word.each_char do |char|
      if @guesses.include? char
        guess_word << char
      else
        guess_word << '-'
      end
    end
    
    guess_word
      
  end
  
  def check_win_or_lose
    return :lose if @wrong_guesses.length > 6
    return :win if !(word_with_guesses.include? '-')
    :play
  end

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

end
