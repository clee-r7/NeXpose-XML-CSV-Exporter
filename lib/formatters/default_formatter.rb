require File.expand_path(File.join(File.dirname(__FILE__), 'formatter'))

class DefaultFormatter < Formatter
  def do_description_format ticket_info
		# Build description section
		formatted_output = ''
		if ticket_info[:description]
			vuln_description_paragraph = build_paragraph ticket_info[:description]
			vuln_description_paragraph.get_paragraph.each do |output|
				do_formated_paragraph formatted_output, output
			end
		end

    # Build Proof
		if ticket_info[:proof]
			vuln_proof_paragraph = build_paragraph ticket_info[:proof]
			vuln_proof_paragraph.get_paragraph.each do |output|
				do_formated_paragraph formatted_output, output
			end
		end

		# Build solution section
		if ticket_info[:solution]
			vuln_solution_paragraph = build_paragraph ticket_info[:solution]
			vuln_solution_paragraph.get_paragraph.each do |output|
				do_formated_paragraph formatted_output, output
			end
		end

    formatted_output
  end

  def do_formated_paragraph appended, output
      if output[:sentence]
        appended << output[:sentence]
        appended << ' '
      else
        if output[:link]
          description = output[:link][0]
          link = output[:link][1]
          line_item = ''
          line_item << description
          line_item << ': '
          line_item << link
          appended << line_item
          appended << ' '
        end
      end
  end
end