require 'csv'

# Read file
file = File.readlines('words.txt')

# Chomp
words = file.map(&:chomp)

def get_word(dict)
  dict[rand(dict.length)].downcase
end

def user_guess(word, _solved_word, used_letters)
  while true
    puts 'Enter one letter'
    input = gets.chomp.downcase
    if used_letters.include?(input)
      puts 'Letter already used'
      next
    elsif word.include?(input) && input.length == 1
      used_letters.push(input)
      return input
    elsif input.length == 1 && !word.include?(input)
      puts "Letter #{input.upcase} does not exist"
      used_letters.push(input)
      return
    end
  end
end

def update_solved(word, solved_word, guess)
  word.each_with_index do |letter, index|
    solved_word[index] = guess if letter == guess
  end
end

def save_game_state(word, used_letters, solved_word, tries)
  CSV.open('hangman.csv', 'w') do |csv|
    csv << ['Word', 'Used Letters', 'Solved Word', 'Tries']
    csv << [word.join(''), used_letters.join(''), solved_word.join(''), tries]
  end
end

def load_game_state
  if File.exist?('hangman.csv')
    csv_data = CSV.read('hangman.csv').last
    [csv_data[0].split(','), csv_data[1].split(''), csv_data[2].split(','), csv_data[3].to_i]
  else
    puts 'No saved game found'
  end
end

def start_game(words)
  tries = 10
  word = get_word(words).split('')
  solved_word = Array.new(word.length, '_')
  used_letters = []

  puts 'New game      -> Enter N'
  puts 'Load game     -> Enter L'
  while true
    user_input = gets.chomp
    if user_input.downcase == 'n'
      break
    elsif user_input.downcase == 'l'
      word, used_letters, solved_word, tries = load_game_state if load_game_state
      break
    end
  end

  while true

    # Display tries
    puts "You have #{tries} #{tries == 1 ? 'try' : 'tries'}"

    # Display solved word
    puts solved_word.join(' ')

    # Player guess
    user_guess = user_guess(word, solved_word, used_letters)

    if user_guess

      # Update solved word
      update_solved(word, solved_word, user_guess)

      # Check if user won
      return puts 'You won' if solved_word == word

    end

    # Decrease tries
    tries -= 1

    if tries <= 0
      puts 'You lost'
      break
    end

    # Ask player every other round if he will continue
    next unless tries.even?

    while true
      puts 'For continue  -> enter C'
      puts 'For save game -> enter S'
      input = gets.chomp
      if input.downcase == 'c'
        break
      elsif input.downcase == 's'
        save_game_state(word, used_letters, solved_word, tries)
        exit
      end
    end
  end
end

start_game(words)
