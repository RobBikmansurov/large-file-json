require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'benchmark-ips', require: 'benchmark/ips'
end

require_relative './task_old'
require_relative './task_report_stats'
require_relative './task_report_stats_quick'

Benchmark.ips do |x|
  x.config(time: 10, warmup: 2)

  x.report("old") { work_old }
  x.report('new') { work }
  x.report('quick') { quick }

  x.compare!
end
