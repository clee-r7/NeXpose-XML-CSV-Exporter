require 'ostruct'
require 'optparse'

#------------------------------------------------------------------------------------------------------
# Defines options to be executed against the NeXpose API
#------------------------------------------------------------------------------------------------------
class Options
    def self.parse(args)
      options = OpenStruct.new
      options.verbose = false
			options.port = 3780
			options.dbn = 'nexpose'
			options.dbu = 'nxpgsql'
			options.separator = ','
			options.host = 'localhost'
			options.report_vuln_only = false
      options.sites = nil
			options.headers = 'Vulnerable Status,Port Details,HostName,IP,Vulnerability Description,Vulnerability Remediations,Unique ID,Operating System,Vulnerability Category,Vulnerability Proof,CVSS Score'

      option_parser = OptionParser.new  do |option_parser|
        option_parser.on("-h host", "The network address of the NeXpose instance - Defaults to 'localhost'") {|arg| options.host=arg.chomp}
        option_parser.on("-u user_name", "The NeXpose user name - Required") {|arg| options.user=arg.chomp}
        option_parser.on("-p password", "The NeXpose password - Required") {|arg| options.password=arg.chomp}
				option_parser.on("-s delimeter", "The report delimiter - Defaults to ','") {|arg| options.separator=arg.chomp}
				option_parser.on("-v [true|false]", "Report on vulnerable data only - Defaults to false") {|arg| options.report_vuln_only=arg.chomp}
        option_parser.on("--sites site1,site2", "A list of sites to report on - Defaults to ALL") {|arg| options.sites=arg.chomp}
				option_parser.on("--port port", "The NSC port - Defaults to 3780") {|arg| options.port=arg.chomp}
				option_parser.on("--ofn file", "The output file name -Required") {|arg| options.ofn=arg.chomp}
				option_parser.on("--headers headers", "A comma separated list of the headers -Default #{options.headers}") {|arg| options.headers=arg.chomp}

        option_parser.on_tail("--help", "Help") do
          puts option_parser
          exit 0
        end
      end

      begin
       option_parser.parse!(args)
        rescue OptionParser::ParseError => e
            puts "#{e}\n\n#{option_parser}"
            exit 1
      end

			options
    end
end