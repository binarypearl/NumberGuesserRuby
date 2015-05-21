#!/usr/bin/ruby

trap("SIGINT") do
	puts "\nCtrl-c captured, you loose!\n"
	exit 1
end

class Numberguesser
	attr_accessor :magic_number
	attr_accessor :result_flag	
	attr_accessor :user_guess
	attr_accessor :guess_count
	attr_accessor :first_guess
	attr_accessor :min_guess
	attr_accessor :max_guess


	def initialize
		@magic_number = nil
		@result_flag = false
		@user_guess = nil
		@guess_count = 1
		@first_guess = true
		@min_guess = 1
		@max_guess = 100
	end

	def begin_game
		@magic_number = 1 + rand(100)
		display_buffer("")
	end

	def display_buffer(too_low_or_too_high_message)
		system "clear"

		if @first_guess == false
			puts too_low_or_too_high_message + "\n"			
		end
	
		print "Guess a number from #{@min_guess} to #{@max_guess}: "
		
	end

	def compare_numbers
		#puts "Magic number is: #{@magic_number}"
		#puts "User guess   is: #{@user_guess}"

		# Convert @user_guess to an integer, so we are comparing integer to integer instead of string to integer.
		@user_guess = @user_guess.to_i

		if @magic_number == @user_guess
			puts "You guessed it!  It took you: #{@guess_count} tries."

			@result_flag = true

		else
			@guess_count += 1
			@first_guess = false

			if @user_guess < @min_guess || @user_guess > @max_guess
				display_buffer("Invalid guess, try again.")

			else
				if @user_guess < @magic_number
					@min_guess = @user_guess + 1

					display_buffer("Guess too low.  Guess again.")

				elsif @user_guess > @magic_number
					@max_guess = @user_guess - 1

					display_buffer("Guess too high.  Guess again.")
			
				end
			end
		end
	end
end

game_object = Numberguesser.new
game_object.begin_game

while game_object.result_flag == false do
	game_object.user_guess = gets.chomp
	game_object.compare_numbers
end 

