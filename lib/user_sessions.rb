# frozen_string_literal: true

require_relative 'user'
require_relative 'session'

# user with sessions
class UserSessions
  attr_reader :user, :sessions

  def initialize(user:, sessions: [])
    @user = user
    @sessions = sessions
  end
end
