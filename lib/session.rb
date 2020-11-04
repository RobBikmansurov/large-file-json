# frozen_string_literal: true

# user`s session
class Session
  attr_reader :id, :user_id, :browser, :time, :date

  def initialize(id:, user_id:, browser:, time:, date:)
    @id = id.to_i
    @user_id = user_id.to_i
    @browser = browser
    @time = time.to_i
    @date = date
  end

  def self.from_data_string(session)
    fields = session.chomp.split(',')
    new(
      id: fields[1],
      user_id: fields[2],
      browser: fields[3],
      time: fields[4],
      date: fields[5]
    )
  end
end
