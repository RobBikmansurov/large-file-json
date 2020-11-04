# frozen_string_literal: true

require 'rspec'
require '../lib/session'

describe 'Session' do
  let(:session_from_string) { Session.from_data_string('session,0,7,Firefox 46,76,2019-02-04') }

  describe '.from_data_string' do
    it 'should be a Session' do
      expect(session_from_string).to be_a(Session)
    end
  end

  describe 'session`s attributes' do
    it 'should has an attributes' do
      expect(session_from_string.id).to eq 0
      expect(session_from_string.user_id).to eq 7
      expect(session_from_string.browser).to eq 'Firefox 46'
      expect(session_from_string.time).to eq 76
      expect(session_from_string.date).to eq '2019-02-04'
    end
  end
end
