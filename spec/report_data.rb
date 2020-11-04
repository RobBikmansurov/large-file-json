# frozen_string_literal: true

require 'rspec'
require '../report_data'

describe 'ReportData' do
  describe '.from_file' do
    let(:file_path) { File.join(File.dirname(__FILE__), 'fixtures', 'data.txt') }
    let(:users_objects) { Reportdata.from_file(file_path) }

    it 'should be a UserObjects' do
      expect(users_objects).to be_a(Array)
    end

    it 'has a collection of UserSessions' do
      expect(users_objects.first).to be_a(UserSessions)
      expect(users_objects.first.user).to be_a(User)
      expect(users_objects.first.sessions.first).to be_a(Session)
    end
  end
end
