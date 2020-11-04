# frozen-string_literal: true

require 'json'

# save report result
module ReportResult
  def self.report_json(report, result_file_name)
    File.write(result_file_name, "#{report.to_json}\n") unless report.empty?
  end
end
