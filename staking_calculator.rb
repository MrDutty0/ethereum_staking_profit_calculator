# frozen_string_literal: true

require_relative 'user_input'
require_relative 'constants'
require_relative 'schedule_generator'

# for calculating Ethereum staking profits
class StakingCalculator
  attr_reader :initial_amount, :yearly_reward_rate, :start_date, :duration_months, :payment_day, :reinvest_rewards

  include ScheduleGenerator

  def initialize(params)
    params.each { |key, value| instance_variable_set("@#{key}", value) }
  end

  def self.create(inputting_data: false)
    params = inputting_data ? UserInput.enter_input_data : {
      initial_amount: DEF_INITIAL_AMOUNT,
      yearly_reward_rate: DEF_YEARLY_REWARD_RATE,
      start_date: Date.parse(DEF_START_DATE),
      duration_months: DEF_DURATION_MONTHS,
      payment_day: DEF_PAYMENT_DAY,
      reinvest_rewards: DEF_REINVEST_REWARDS
    }
    new(params)
  end

  def calculate_and_generate_profit_schedule
    schedule = calculate_staking_profit_schedule
    generate_csv_profit_schedule(schedule)
  end

  private

  def calculate_staking_profit_schedule
    schedule = []

    total_reward_accumulated = 0
    reward_date = start_date

    (1..duration_months).each do |line_no|
      investment_amount = calc_investment_amount(total_reward_accumulated)
      interest_rate = calc_interest_rate(reward_date)

      reward_amount = calc_next_monthly_profit(reward_date, investment_amount, interest_rate)

      reward_date = calc_next_reward_date(reward_date)

      schedule << form_schedule_column(line_no, reward_date, investment_amount, reward_amount, total_reward_accumulated, interest_rate)

      total_reward_accumulated += reward_amount
    end
    schedule
  end

  def calc_interest_rate(reward_date)
    reward_date >= Date.parse(DEF_REWARD_RATE_CHANGING_DATE) ? CHANGED_REWARD_RATE : yearly_reward_rate
  end

  def calc_investment_amount(accumulation)
    reinvest_rewards ? initial_amount + accumulation : initial_amount
  end

  def calc_next_monthly_profit(date, investment_amount, interest_rate)
    day_interest_rate = calc_day_interest_rate(date.year, interest_rate)
    curr_day = date.day

    if payment_day > curr_day
      days_until_payment = payment_day - curr_day + 1
      days_until_payment * day_interest_rate
    else
      left_starting_month_days = calc_days_in_month(date.year, date.month) - curr_day
      total_paying_days = left_starting_month_days + payment_day

      total_paying_days * day_interest_rate * investment_amount
    end
  end

  def calc_next_reward_date(date)
    if date.day < payment_day
      date - (date.day - payment_day)
    else
      Date.new(date.year, date.month, payment_day) << -1
    end
  end

  def calc_day_interest_rate(year, interest_rate)
    days_in_year = calc_days_in_year(year)

    interest_rate.to_f / 100 / days_in_year
  end

  def calc_days_in_year(year)
    Date.new(year).leap? ? 366 : 365
  end

  def calc_days_in_month(year, month)
    Date.new(year, month, -1).day
  end
end
