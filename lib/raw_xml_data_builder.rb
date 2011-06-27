require 'rubygems'
require 'rex/parser/nexpose_xml'

class RawXMLDataBuilder

  def initialize client_api, parse_vuln_states_only
	@client_api = client_api
	@vuln_map = {}

	@parser = Rex::Parser::NexposeXMLStreamParser.new
	@parser.parse_vulnerable_states_only parse_vuln_states_only
	@parser.callback = proc { |type, value|
	  case type
		when :host
		  @host_data << value
		when :vuln
		  @vuln_data << value
	  end
	}
  end

  def get_node_data site_id
	# Reset for each call
	@host_data = []
	@vuln_data = []

	# For multiple calls the filter isn't reset so we have to recreate the instance
	adhoc_report_generator = Nexpose::ReportAdHoc.new @client_api
	adhoc_report_generator.addFilter 'site', site_id
	data = adhoc_report_generator.generate

	# The only way to get the corresponding device-id is though mappings
	site_device_listing = @client_api.site_device_listing site_id

	REXML::Document.parse_stream(data.to_s, @parser)

	populate_vuln_map
	build_node_data site_device_listing
  end

  def get_vuln_data
	@vuln_map
  end

  #------------------------------------------------------------------------------------------------------
  #
  #------------------------------------------------------------------------------------------------------
  def build_node_data site_device_listing
	res = []
	@host_data.each do |host_data|
	  ip = host_data["addr"]
	  device_id = get_device_id ip, site_device_listing

	  # Just take the first name
	  names = host_data["names"]
	  name = ''
	  unless names.nil? or names.empty?
		name = names[0]
	  end

	  fingerprint = ''
	  fingerprint << (host_data["os_vendor"] || '')
	  fingerprint << ' '
	  fingerprint << (host_data["os_family"] || '')

	  host_data["vulns"].each { |vuln_id, vuln_info|

		vkey = vuln_info["key"] || ''
		vuln_endpoint_data = vuln_info["endpoint_data"]

		port = ''
		protocol = ''
		if vuln_endpoint_data
		  port = vuln_endpoint_data["port"] || ''
		  protocol = vuln_endpoint_data["protocol"] || ''
		end

		res << {
				:ip => ip,
				:device_id => device_id,
				:name => name,
				:fingerprint => fingerprint,
				:vuln_id => vuln_id,
				:vuln_status => vuln_info["status"],
				:port => port,
				:protocol => protocol,
				:vkey => vkey,
				:proof => vuln_info["proof"]
		}
	  }
	end

	res
  end

  def populate_vuln_map
	@vuln_data.each do |vuln_data|
	  id = vuln_data["id"].to_s.downcase.chomp
	  unless @vuln_map.has_key? id
		@vuln_map[id] = {
				:severity => vuln_data["severity"],
				:title => vuln_data["title"],
				:description => vuln_data["description"],
				:solution => vuln_data["solution"],
				:cvss => vuln_data["cvssScore"]
		}
	  end
	end
  end

  def get_device_id ip, site_device_listing
	site_device_listing.each do |device_info|
	  if	device_info[:address] =~ /#{ip}/
		return device_info[:device_id]
	  end
	end
  end

end