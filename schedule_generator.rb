# frozen_string_literal: true

require 'csv'

# Generates profit schedule
module ScheduleGenerator
  def generate_csv_profit_schedule(schedule)
    csv_header = ['Line #', 'Reward Date', 'Investment Amount', 'Reward Amount', 'Total Reward Amount Till that date', 'Staking Reward Rate']
    CSV.open('staking_profit_schedule.csv', 'w') do |csv|
      csv << csv_header
      schedule.each do |schedule_row|
        csv << schedule_row.values_at(
          :line_no, :reward_date, :investment_amount, :reward_amount, :total_reward_accumulated, :interest_rate
        )
      end
    end
  end

  def form_schedule_column(line_no, reward_date, investment_amount, reward_amount, total_reward_accumulated, interest_rate)
    {
      line_no: line_no,
      reward_date: reward_date.strftime('%Y-%m-%d'),
      investment_amount: format('%.6f', investment_amount),
      reward_amount: format('%.6f', reward_amount),
      total_reward_accumulated: format('%.6f', total_reward_accumulated),
      interest_rate: "#{format('%.2f', interest_rate)}%"
    }
  end
end
