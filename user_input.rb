# frozen_string_literal: true

require 'date'

# Gets input from user
class UserInput
  def self.enter_input_data
    input_obj = new
    {
      initial_amount: input_obj.input('ETH initial investment amount', entering_float: true).to_f,
      yearly_reward_rate: input_obj.input('yearly staking reward rate in %', entering_integer: true).to_i,
      start_date: Date.parse(input_obj.input('staking start date', entering_date: true)),
      duration_monts: input_obj.input('staking duration in months', entering_integer: true).to_i,
      payment_day: input_obj.input('reward payment', entering_integer: true).to_i,
      reinvest_rewards: input_obj.input('if you want to reinvest staking rewards (Y/n)', entering_boolean: true) == 'y'
    }
  end

  def input(input_data_text,
            entering_float: false,
            entering_integer: false,
            entering_date: false,
            entering_boolean: false)

    valid_input = input_requirement_lambda(entering_float, entering_integer, entering_date, entering_boolean)

    input_text = "Enter #{input_data_text}.\n"
    error_count = 0

    loop do
      clear_screen
      print "(#{error_count}) " unless error_count.zero?
      print input_text
      input = gets.chomp

      return input if valid_input.call(input)

      error_count += 1
    end
  end

  private

  def input_requirement_lambda(entering_float, entering_integer, entering_date, entering_boolean)
    return ->(user_input) { /^(\d+(\.\d+)?|0\.\d+)$/.match(user_input) } if entering_float
    return ->(user_input) { /^\d+$/.match(user_input) } if entering_integer
    return ->(user_input) { /^[yn]$/i.match(user_input) } if entering_boolean

    # checking for valid date
    lambda do |user_input|
      Date.parse(user_input)
    rescue Date::Error
      false
    end
  end

  def clear_screen
    puts "\e[2J"
  end
end
