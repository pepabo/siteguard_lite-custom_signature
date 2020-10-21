require "siteguard_lite/custom_signature/text_line_parser"

module SiteguardLite
  module CustomSignature
    class TextLoader
      def self.load(text)
        rules = []
        rule = nil

        line_parser = TextLineParser.new
        text.split("\n").each do |line|
          parsed = line_parser.parse(line)

          # collect each line into the rules
          if rule&.name == parsed[:name]
            # This is the continuation from the previous line
            rule.add_condition(*parsed[:condition].fetch_values(:key, :value, :comparison_methods))
            rule.exclusion_action = parsed[:exclusion_action]
            rule.signature = parsed[:signature]
          else
            # This line is a new rule
            rules << rule if rule
            rule = Rule.new(
              enable: parsed[:enable],
              action: parsed[:action],
              filter_lifetime: parsed[:filter_lifetime],
              name: parsed[:name],
              comment: parsed[:comment],
              exclusion_action: parsed[:exclusion_action],
              signature: parsed[:signature],
            )
            rule.add_condition(*parsed[:condition].fetch_values(:key, :value, :comparison_methods))
          end
        end

        rules << rule if rule

        rules
      end
    end
  end
end
