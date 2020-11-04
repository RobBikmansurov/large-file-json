# frozen_string_literal: true

require 'rspec'
require '../lib/user'

describe 'User' do
  let(:user_from_string) { User.from_data_string('user,3,Kieth,Noble,20') }

  describe '.from_data_string' do
    it 'should be a User' do
      expect(user_from_string).to be_a(User)
    end
  end

  describe 'user`s attributes' do
    it 'should has an attributes' do
      expect(user_from_string.id).to eq 3
      expect(user_from_string.first_name).to eq 'Kieth'
      expect(user_from_string.last_name).to eq 'Noble'
      expect(user_from_string.age).to eq 20
    end
  end
end
