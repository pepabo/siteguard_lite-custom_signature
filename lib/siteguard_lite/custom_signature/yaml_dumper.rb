require "active_support/core_ext/hash/indifferent_access"

module SiteguardLite
  module CustomSignature
    class YamlDumper
      def self.dump(rules)
        {
          rules: rules.map { |r| r.to_hash }
        }.with_indifferent_access.deep_stringify_keys.to_hash.to_yaml
      end
    end
  end
end
