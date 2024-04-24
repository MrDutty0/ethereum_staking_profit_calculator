# frozen_string_literal: true

require_relative 'user_input'

DEF_INITIAL_AMOUNT = 10.0
DEF_YEARLY_REWARD_RATE = 4
DEF_START_DATE = '2024-12-14'
DEF_DURATION_MONTS = 24
DEF_PAYMENT_DAY = 1
DEF_REINVEST_REWARDS = false

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
      initial_amount: DEF_INITIAL_AMOUNT,
      yearly_reward_rate: DEF_YEARLY_REWARD_RATE,
      start_date: Date.parse(DEF_START_DATE),
      duration_monts: DEF_DURATION_MONTS,
      payment_day: DEF_PAYMENT_DAY,
      reinvest_rewards: DEF_REINVEST_REWARDS
    }
    new(params)
  end

  private

  def calc_next_monthly_profit(date, investment_amount_eth )
    day_interest = calc_month_day_interest_rate(date.year, date.month)
    curr_day = date.day

    if payment_day > curr_day
      # Calculates interest from the current day until the payment day in the same month

      days_until_payment = payment_day - curr_day
      days_until_payment * day_interest
    else
      # Calculates interest for the remaining days in the current month
      left_starting_month_days = calc_days_in_month(date.year, date.month) - curr_day
      starting_profit = left_starting_month_days * day_interest * investment_amount_eth

      # Calculates interest for the next month until the payment day
      next_month_date = date << 1
      next_month_day_interest = calc_month_day_interest_rate(next_month_date.year, next_month_date.month)
      next_month_profit = payment_day * next_month_day_interest * investment_amount_eth

      starting_profit + next_month_profit
    end
  end

  def calc_next_reward_date(date)
    if date.day < payment_day
      date - (date.day - payment_day)
    else
      Date.new(date.year, date.month, payment_day) << -1
    end
  end

  def calc_month_day_interest_rate(year, month)
    days_in_year = calc_days_in_year(year)
    days_in_month = calc_days_in_month(year, month)

    @yearly_reward_rate.to_f / 100 / days_in_year * days_in_month
  end

  def calc_days_in_year(year)
    Date.new(year).leap? ? 366 : 365
  end

  def calc_days_in_month(year, month)
    Date.new(year, month, -1).day
  end
end
