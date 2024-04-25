# frozen_string_literal: true

require_relative 'staking_calculator'

staking_calculator = StakingCalculator.create
# Comment the line above and uncomment the line below to enable Bonus Task 2:
# staking_calculator = StakingCalculator.create(inputting_data: true)

staking_calculator.calculate_and_generate_profit_schedule
