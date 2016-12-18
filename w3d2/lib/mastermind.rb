class Code
  include Enumerable
  attr_reader :pegs
  
  PEGS = { "b" => "B",
            "y" => "Y",
            "r" => "R",
            "p" => "P",
            "o" => "O",
            "g" => "G",}
  
  def initialize(pegs)
    @pegs = pegs
  end

  def self.parse(input)
  pegs = []
    
   input.each_char do |peg|
        if PEGS.keys.include? (peg.downcase)
            pegs << peg.downcase
        else
            raise "Not a peg"
        end
    end
    
    Code.new(pegs)
  end
  
  def self.random
     pegs = PEGS.keys.repeated_combination(4).to_a.sample
     
    Code.new(pegs)
  end

  
  def[](arr)
    pegs[arr]
  end
  
 def exact_matches(comp_code)
    exact_match = 0
    0.upto(3) do |num|
        if self[num] == comp_code[num]
            exact_match += 1
        end
    end
    exact_match
 end
  
  def near_matches(comp_code)
    near_match = 0
    my_counts = Hash.new(0)
    comp_counts = Hash.new(0)
    
    self.pegs.each do |peg|
        my_counts[peg] += 1
    end
    
    comp_code.pegs.each do |peg|
        comp_counts[peg] += 1
    end
    
    my_counts.each do |key,val|
        if comp_counts.has_key?(key)
            near_match += [val,comp_counts[key]].min
        end
    end
   near_match - self.exact_matches(comp_code)
  end
      
  def ==(comp_code)
    return false unless comp_code.is_a?(Code)

    return true if self.pegs == comp_code.pegs
  end
      
end

class Game
  attr_reader :secret_code
  
  def initialize(secret_code = Code.random)
      @secret_code = secret_code
  end
  
  def play
      10.times do 
          guess = get_guess
          display_matches(guess)
          
          if guess == @secret_code
            puts "You win this time... HUMAN."
            return
          end
      end
  end
  
  def get_guess
      puts "Greetings, human. Pick your colors!"
      
     begin
         Code.parse(gets.chomp)
     rescue
        puts "That's not a code."
        retry
     end
  end
  
  def display_matches(guess)
      puts "Well, you have #{(@secret_code.exact_matches(guess))} exact matches and #{(@secret_code.near_matches(guess))} near_matches. Try again."
  end

end

if __FILE__ == $PROGRAM_NAME
  Game.new.play
end