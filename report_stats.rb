#!/home/rob/.rbenv/shims/ruby
#
#!/usr/local/bin/ruby

# process data from txt and create json report
# run:
# ./report_stats.rb data.txt report.json
# or just
# ./report_stats.rb

require_relative './task_report_stats_quick'

data_file_name = ARGV[0] || 'data.txt'
report_file_name = ARGV[1] || 'result.json'

quick(data_file_name, report_file_name)

