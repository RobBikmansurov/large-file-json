# frozen_string_literal: true

# user
class User
  attr_reader :id, :first_name, :last_name, :age

  def self.from_data_string(user)
    fields = user.chomp.split(',')
    new(
      id: fields[1],
      first_name: fields[2],
      last_name: fields[3],
      age: fields[4]
    )
  end

  def initialize(id:, first_name:, last_name:, age:)
    @id = id.to_i
    @first_name = first_name
    @last_name = last_name
    @age = age.to_i
  end
end
