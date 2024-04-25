# frozen_string_literal: true

require_relative 'staking_calculator'

staking_calculator = StakingCalculator.create

staking_calculator.calculate_and_generate_profit_schedule
