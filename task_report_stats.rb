# frozen_string_literal: true

# Тут находится программа, выполняющая обработку данных из файла.
# Тест показывает как программа должна работать.
# В этой программе нужно обработать файл данных data_large.txt.

# Ожидания от результата:

# Корректная обработатка файла data_large.txt;
# Проведена оптимизация кода и представлены ее результаты;
# Production-ready код;
# Применены лучшие практики;

require 'json'
require 'date'

class User
  attr_reader :attributes, :sessions

  def initialize(attributes:, sessions:)
    @attributes = attributes
    @sessions = sessions
  end
end

def parse_user(user)
  fields = user.split(',')
  parsed_result = {
    'id' => fields[1],
    'first_name' => fields[2],
    'last_name' => fields[3],
    'age' => fields[4]
  }
end

def parse_session(session)
  fields = session.split(',')
  parsed_result = {
    'user_id' => fields[1],
    'session_id' => fields[2],
    'browser' => fields[3],
    'time' => fields[4],
    'date' => fields[5]
  }
end

def collect_stats_from_users(report, users_objects, &block)
  users_objects.each do |user|
    user_key = "#{user.attributes['first_name']} #{user.attributes['last_name']}"
    report['usersStats'][user_key] ||= {}
    report['usersStats'][user_key] = report['usersStats'][user_key].merge(block.call(user))
  end
end

def work
  users = []
  sessions = []

  lines = File.readlines('data.txt')
  lines.each do |line|
    cols = line.split(',')
    users += [parse_user(line)] if cols[0] == 'user'
    sessions += [parse_session(line)] if cols[0] == 'session'
  end

  # Отчёт в json
  #   - Сколько всего юзеров +
  #   - Сколько всего уникальных браузеров +
  #   - Сколько всего сессий +
  #   - Перечислить уникальные браузеры в алфавитном порядке через запятую и капсом +
  #
  #   - По каждому пользователю
  #     - сколько всего сессий +
  #     - сколько всего времени +
  #     - самая длинная сессия +
  #     - браузеры через запятую +
  #     - Хоть раз использовал IE? +
  #     - Всегда использовал только Хром? +
  #     - даты сессий в порядке убывания через запятую +

  report = {}

  report[:totalUsers] = users.size

  # Подсчёт количества уникальных браузеров
  browsers = sessions.map { |session| session['browser'] }
  report['uniqueBrowsersCount'] = browsers.uniq.count

  report['totalSessions'] = sessions.count

  report['allBrowsers'] = browsers.map(&:upcase).uniq.sort.join(',')

  # Статистика по пользователям
  users_objects = users.map do |user|
    user_sessions = sessions.select { |session| session['user_id'] == user['id'] }
    User.new(attributes: user, sessions: user_sessions)
  end

  users = nil
  sessions = nil

  report['usersStats'] = {}

  # Собираем количество сессий по пользователям
  collect_stats_from_users(report, users_objects) do |user|
    { 'sessionsCount' => user.sessions.count }
  end

  # Обрабатываем время сессий:
  collect_stats_from_users(report, users_objects) do |user|
    times = user.sessions.map { |s| s['time'].to_i }
    {
      # Собираем количество времени по пользователям
      'totalTime' => "#{times.sum} min.",
      # Выбираем самую длинную сессию пользователя
      'longestSession' => "#{times.max} min."
    }
  end

  # Обрабатываем браузеры
  collect_stats_from_users(report, users_objects) do |user|
    browsers = user.sessions.map { |s| s['browser'].upcase }
    {
      # Браузеры пользователя через запятую
      'browsers' => browsers.map.sort.join(', '),
      # Хоть раз использовал IE?
      'usedIE' => browsers.any? { |b| b =~ /INTERNET EXPLORER/ },
      # Всегда использовал только Chrome?
      'alwaysUsedChrome' => browsers.all? { |b| b =~ /CHROME/ }
    }
  end

  # Даты сессий через запятую в обратном порядке в формате iso8601
  collect_stats_from_users(report, users_objects) do |user|
    { 'dates' => user.sessions.map { |s| s['date'] }.map { |d| Date.parse(d) }.sort.reverse.map(&:iso8601) }
  end

  File.write('result.json', "#{report.to_json}\n")
end

work
