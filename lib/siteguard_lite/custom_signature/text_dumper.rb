module SiteguardLite
  module CustomSignature
    class TextDumper
      def self.dump(rules)
        rules.map { |r| r.to_text }.join("\n") + "\n"
      end
    end
  end
end
