# frozen_string_literal: true

require 'rspec'
require '../lib/user_sessions'

describe 'UserSessions' do
  let(:user) { User.from_data_string('user,3,Kieth,Noble,20') }
  let(:session1) { Session.from_data_string('session,0,7,Firefox 46,76,2019-02-04') }
  let(:session2) { Session.from_data_string('session,1,7,Opera,24,2019-03-04') }
  let(:user_sessions) { UserSessions.new(user: user, sessions: [session1, session2]) }

  describe '.initialize' do
    it 'should be a UserSessions' do
      expect(user_sessions).to be_a(UserSessions)
    end
  end

  describe 'user_sessions`s attributes' do
    it 'should has an attributes' do
      expect(user_sessions.user).to be_a(User)
      expect(user_sessions.user).to eq user
      expect(user_sessions.sessions).to be_a(Array)
      expect(user_sessions.sessions.first).to be_a(Session)
      expect(user_sessions.sessions.first).to eq session1
    end
  end
end
