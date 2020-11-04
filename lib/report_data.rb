# frozen_string_literal: true

require_relative 'user_sessions'

# process source and prepare data hash
module ReportData
  def self.from_file(file_name)
    user = nil
    sessions = []
    users_objects = []
    File.open(file_name).each_line do |line|
      if line.start_with?('user')
        users_objects << UserSessions.new(user: user, sessions: sessions) unless sessions.empty?
        user = User.from_data_string(line)
        sessions = []
      elsif line.start_with?('session')
        session = Session.from_data_string(line)
        sessions << session
      end
    end
    # add info for last user
    users_objects << UserSessions.new(user: user, sessions: sessions) unless sessions.empty?
  end
end
