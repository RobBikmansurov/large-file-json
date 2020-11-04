# frozen_string_literal: true

require 'json'
require 'date'

# generate report from users_objects
class ReportGenerator
  attr_reader :report

  def initialize(data = {})
    @users_objects = data
    @report = {}
  end

  def generate_stats
    # common stats
    report[:totalUsers] = @users_objects.count

    # Подсчёт количества уникальных браузеров
    unique_browsers = []
    sessions_count = 0
    @users_objects.each do |user_sessions|
      unique_browsers += user_sessions.sessions.map(&:browser).map(&:upcase)
      unique_browsers.uniq!
      sessions_count += user_sessions.sessions.count
    end

    report['uniqueBrowsersCount'] = unique_browsers.count
    report['totalSessions'] = sessions_count
    report['allBrowsers'] = unique_browsers.sort.join(',')

    # users styats
    report['usersStats'] = {}

    # Собираем количество сессий по пользователям
    collect_stats_from_users(@report, @users_objects) do |user_sessions|
      { 'sessionsCount' => user_sessions.sessions.count }
    end

    # Собираем количество времени по пользователям
    collect_stats_from_users(@report, @users_objects) do |user_sessions|
      { 'totalTime' => "#{user_sessions.sessions.map(&:time).sum} min." }
    end

    # Выбираем самую длинную сессию пользователя
    collect_stats_from_users(@report, @users_objects) do |user_sessions|
      { 'longestSession' => "#{user_sessions.sessions.map(&:time).max} min." }
    end

    # Браузеры пользователя через запятую
    collect_stats_from_users(@report, @users_objects) do |user_sessions|
      { 'browsers' => user_sessions.sessions.map(&:browser).map(&:upcase).sort.join(', ') }
    end

    # Хоть раз использовал IE?
    collect_stats_from_users(@report, @users_objects) do |user_sessions|
      { 'usedIE' => user_sessions.sessions.map(&:browser).any? { |b| b.upcase =~ /INTERNET EXPLORER/ } }
    end

    # Всегда использовал только Chrome?
    collect_stats_from_users(report, @users_objects) do |user_sessions|
      { 'alwaysUsedChrome' => user_sessions.sessions.map(&:browser).all? { |b| b.upcase =~ /CHROME/ } }
    end

    # Даты сессий через запятую в обратном порядке в формате iso8601
    collect_stats_from_users(report, @users_objects) do |user_sessions|
      { 'dates' => user_sessions.sessions.map(&:date).map { |d| Date.parse(d) }.sort.reverse.map(&:iso8601) }
    end
  end

  private

  def collect_stats_from_users(report, users_objects, &block)
    users_objects.each do |user_sessions|
      user_key = "#{user_sessions.user.first_name} #{user_sessions.user.last_name}"
      report['usersStats'][user_key] ||= {}
      report['usersStats'][user_key] = report['usersStats'][user_key].merge(block.call(user_sessions))
    end
  end
end
