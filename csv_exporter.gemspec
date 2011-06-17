require 'rubygems'
require 'rake'

Gem::Specification.new do |spec|
	spec.name = 'nexpose_csv_generator'
	spec.version = '0.0.1'
	spec.platform=Gem::Platform::RUBY
  spec.description=
<<Description
  This is a tool that connects to an NSC instance to generate a user specified delimited report with the following fields:
	Vulnerable Status || Port Details || IP || Hostname || Vulnerability Description || Vulnerability Remediation || Unique ID || Operating System || Vulnerability Category || Proof || CVSS Score

  Execute 'csv_creator --help' for options after installing this gem.
Description
	spec.summary=
<<Summary
	Connects to an NSC instance to generate a user specified delimited report with the following fields:
	Vulnerable Status || Port Details || DNS || Vulnerability Information || Unique ID || Operating System || Vulnerability Category || Proof || CVSS Score
Summary
	spec.add_dependency 'nexpose', '>= 0.0.3'
	spec.author = 'Christopher Lee'
	spec.email = 'christopher_lee@rapid7.com'
	spec.executables = ['csv_creator']
	spec.files = FileList['lib/*', 'lib/formatters/*'].to_a
end
