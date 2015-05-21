#!/usr/bin/ruby

# number_guesser.rb - Guess a number between 1 and 100
#
# Originally a game from the Dataman, you have to guess a number between 1 and 100 that this script picked.
# It will help you guess by showing what your current min and max possibilties are.

# --Shaun Miller (05/20/2015) binarypearl@gmail.com

# Colors:
# There is a 'colorize' gem that is pretty cool, but I don't know to easily include that at this point,
# so I'm using straight up ansi escape sequences to print colors instead for portability.
#
# See here: one of the post shows the raw codes: http://stackoverflow.com/questions/1489183/colorized-ruby-output

# Trap ctrl-c and exit gracefully.
trap("SIGINT") do
	puts "\n" + "\033[31m" + "Ctrl-c captured, you lose!\n"
	exit 1
end

class Numberguesser
	attr_accessor :magic_number	# This is the number the user is trying to guess.
	attr_accessor :result_flag	# This is how we break out of the main loop once the number has been guessed.
	attr_accessor :user_guess	# This holds the value that the user guessed.
	attr_accessor :guess_count	# Keep track of how many tries it took the user.
	attr_accessor :min_guess	# Keeps track of the current minimum possible guess.
	attr_accessor :max_guess	# Keeps track of the current maximum possible guess.

	
	# Upon creation of the object, initialize the instance variables appropriately.
	def initialize
		@magic_number = nil
		@result_flag = false
		@user_guess = nil
		@guess_count = 1
		@min_guess = 1
		@max_guess = 100
	end
	
	# Run this code at the beginning of a new game.  This is part of how we handle running multiple new games within the same run of the executable,
	# although we aren't there yet.
	def begin_game
		@magic_number = 1 + rand(100)
		display_buffer("\033[32m" + "Waiting for input.")
	end

	# Once we are ready to display text, this is what gets called.
	def display_buffer(too_low_or_too_high_message)
		system "clear" or system "cls"

		# Start out with bold yellow (really brown + bold).  Use print to not print a newline.
		print "\033[1m"	
		print "\033[33m"

		puts "Welcome to the number guessing game.\n\n"

		puts "\033[37m" + "Status: " + too_low_or_too_high_message + "\n\n"			
	
		print "\033[34m" + "Guess a number from " + "\033[35m"  + "#{@min_guess} " + "\033[34m" + "to " + "\033[36m" + "#{@max_guess}: " + "\033[37m"
	end

	# compare_numbers() is what will actually see if you got the right number, if it was too low or too high, whether 
	# the data is valid or not...etc.
	def compare_numbers
		# Convert @user_guess to an integer, so we are comparing integer to integer instead of string to integer.
		@user_guess = @user_guess.to_i

		if @magic_number == @user_guess
			puts "\033[32m" + "You guessed it!  It took you: #{@guess_count} tries."

			@result_flag = true

		else
			@guess_count += 1
	
			# Test for invalid data.  Don't count that towards the guess count.
			if @user_guess < @min_guess || @user_guess > @max_guess
				display_buffer("\033[33m" + "Invalid guess, try again.")

			else
				if @user_guess < @magic_number
					@min_guess = @user_guess + 1

					display_buffer("\033[31m" + "Guess too low.  Guess again.")

				elsif @user_guess > @magic_number
					@max_guess = @user_guess - 1

					display_buffer("\033[31m" + "Guess too high.  Guess again.")
			
				end
			end
		end
	end
end

# Create our new object and begin the game:
game_object = Numberguesser.new
game_object.begin_game

# While we haven't guessed the number, get a new number and try again.
while game_object.result_flag == false do
	game_object.user_guess = gets.chomp
	game_object.compare_numbers
end 

