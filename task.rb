#!/home/rob/.rbenv/shims/ruby
# frozen_string_literal: true

# !/usr/local/bin/ruby

# process data from txt and create json report
# run:
# ./main.rb data.txt report.json
# or just
# ./main.rb

require_relative 'lib/report_generator'
require_relative 'lib/report_data'
require_relative 'lib/report_result'

data_file_name = ARGV[0] || 'data.txt'
report_file_name = ARGV[1] || 'result.json'

# data_file_name = './data/data.txt'
Abort "Error. File '#{data_file_name}'' not found!" unless File.exist?(data_file_name)

puts "Process file `#{data_file_name}` ..."
users_objects = ReportData.from_file(data_file_name)

report_generator = ReportGenerator.new(users_objects)

report_generator.generate_stats

report = report_generator.report

ReportResult.report_json(report, report_file_name)
puts "... completed. `#{report_file_name}` was written."
