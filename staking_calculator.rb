# frozen_string_literal: true

require_relative 'user_input'

# for calculating Ethereum staking profits
class StakingCalculator
  attr_reader :initial_amount, :yearly_reward_rate, :start_date, :duration, :payment_day, :reinvest_rewards

  def initialize(params)
    @initial_amount = params[:initial_amount]
    @yearly_reward_rate = params[:yearly_reward_rate]
    @start_date = params[:start_date]
    @duration = params[:duration]
    @payment_day = params[:payment_day]
    @reinvest_rewards = params[:reinvest_rewards]
  end

  def self.create(inputting_data: false)
    params = inputting_data ? UserInput.enter_input_data : {
      initial_amount: 10.0,
      yearly_reward_rate: 7,
      start_date: Date.parse('2020-11-10'),
      duration_monts: 24,
      payment_day: 15,
      reinvest_rewards: false
    }
    new(params)
  end
end
